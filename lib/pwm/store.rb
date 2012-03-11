require 'date'

module Pwm
  class Store
    class FileAlreadyExistsError < StandardError
      def initialize(file)
        super("The file #{file} already exists")
      end
    end

    class NotInitializedError < StandardError
      def initialize(file)
        super("The store at #{file} was not initialized yet")
      end
    end

    class WrongMasterPasswordError < StandardError
      def initialize
        super("The master password is wrong")
      end
    end

    class FileNotFoundError < StandardError
      def initialize(file)
        super("The file #{file} for the store was not found")
      end
    end

    class KeyNotFoundError < StandardError
      def initialize(key)
        super("No entry was found for #{key}")
      end
    end

    class BlankError < StandardError
      def initialize(what)
        super("#{what} is required")
      end
    end

    class BlankKeyError < BlankError
      def initialize
        super("Key")
      end
    end

    class BlankValueError < BlankError
      def initialize
        super("Value")
      end
    end

    class << self
      alias_method :load, :new

      DEFAULT_PASSWORD_POLICY = ReasonableComplexityPasswordPolicy.new

      #
      # Constructs a new store (not only the object, but also the file behind it).
      #
      def new(file, master_password, options = {})
        if File.exists?(file) && !options[:force] # don't allow accedidential override of existing file
          raise FileAlreadyExistsError.new(file)
        else
          password_policy.validate!(master_password)
          store = load(file, master_password)
          store.reset!
        end

        store
      end

      #
      # Opens an existing store. Throws if the backing file does not exist or isn't initialized.
      #
      def open(file, master_password)
        raise FileNotFoundError.new(file) unless File.exists?(file)
        store = load(file, master_password)
        store.authenticate # do not allow openeing without successful authentication
        store
      end

      def password_policy
        @password_policy || DEFAULT_PASSWORD_POLICY
      end

      def password_policy=(policy)
        @password_policy = policy
      end
    end

    #
    # Create a new store object by loading an existing file.
    #
    # Beware: New is overridden; it performs additional actions after before and after #initialize
    #
    def initialize(file, master_password)
      @backend = PStore.new(file, true)
      @backend.ultra_safe = true
      @master_password = master_password
    end

    #
    # (Re-) Initialize the database
    #
    def reset!
      @backend.transaction{
        @backend[:user] = {}
        @backend[:system] = {}
        @backend[:system][:created] = DateTime.now
        @backend[:system][:salt] = encrypt(Random.rand.to_s)
      }
    end

    #
    # Check that the master password is correct. This is done to prevent opening an existing but blank store with the wrong password.
    #
    def authenticate
      begin
        @backend.transaction(true){
          raise NotInitializedError.new(@backend.path.path) unless @backend[:user] && @backend[:system] && @backend[:system][:created]
          check_salt!
        }
      rescue OpenSSL::Cipher::CipherError
        raise WrongMasterPasswordError
      end
    end

    #
    # Return the value stored under key
    #
    def get(key)
      raise BlankKeyError if key.blank?
      @backend.transaction{
        timestamp!(:last_accessed)
        value = @backend[:user][encrypt(key)]
        raise KeyNotFoundError.new(key) unless value
        decrypt(value)
      }
    end

    #
    # Store value stored under key
    #
    def put(key, value)
      raise BlankKeyError if key.blank?
      raise BlankValueError if value.blank?
      @backend.transaction{
        timestamp!(:last_modified)
        @backend[:user][encrypt(key)] = encrypt(value)
      }
    end

    #
    # Delete the value that is stored under key and return it
    #
    def delete(key)
      raise BlankKeyError if key.blank?
      @backend.transaction{
        timestamp!(:last_modified)
        old_value = @backend[:user].delete(encrypt(key))
        raise KeyNotFoundError.new(key) unless old_value
        decrypt(old_value)
      }
    end

    #
    # Return all keys, optionally filtered by filter
    #
    def list(filter = nil)
      @backend.transaction(true){
        result = @backend[:user].keys.collect{|k| decrypt(k)}

        if filter.blank?
          result
        else
          result.select{|k,v| k =~ /#{filter}/}
        end
      }
    end

    #
    # Return all entries
    #
    def all
      result = {}
      @backend.transaction(true){
        @backend[:user].each{|k,v| result[decrypt(k)] = decrypt(v)}
      }
      result
    end

    #
    # Change the master password to +new_master_password+. Note that we don't take a password confirmation here.
    # This is up to a UI layer.
    #
    def change_password!(new_master_password)
      self.class.password_policy.validate!(new_master_password)

      @backend.transaction{
        # Decrypt each key and value with the old master password and encrypt them with the new master password
        copy = {}
        @backend[:user].each{|k,v|
          new_key = Encryptor.encrypt(decrypt(k), :key => new_master_password)
          new_val = Encryptor.encrypt(decrypt(v), :key => new_master_password)
          copy[new_key] = new_val
        }

        # re-write user branch with newly encrypted keys and values
        @backend[:user] = copy

        # from now on, use the new master password as long as the object lives
        @master_password = new_master_password

        timestamp!(:last_modified)
        @backend[:system][:salt] = encrypt(Random.rand.to_s)
      }
    end

    #
    # Return the date when the store was created
    #
    def created
      @backend.transaction(true){@backend[:system][:created]}
    end

    #
    # Return the date when the store was last accessed
    #
    def last_accessed
      @backend.transaction(true){@backend[:system][:last_accessed]}
    end

    #
    # Return the date when the store was last modified
    #
    def last_modified
      @backend.transaction(true){@backend[:system][:last_modified]}
    end

    #
    # Return the path to the file backing this store
    #
    def path
      @backend.path
    end

    private

    #
    # Adds or updates the time-stamp stored under symbol
    #
    # This method must run within a PStore read/write transaction.
    #
    def timestamp!(sym)
      @backend[:system][sym] = DateTime.now
    end

    #
    # Return the encrypted +value+ (uses the current master password)
    #
    def encrypt(value)
      Encryptor.encrypt(value, :key => @master_password)
    end

    #
    # Return the decrypted +value+ (uses the current master password)
    #
    def decrypt(value)
      Encryptor.decrypt(value, :key => @master_password)
    end

    #
    # Attempts to decrypt the system salt. Throws if the master password is incorrect.
    #
    # This method must run within a PStore transaction (may be read-only).
    #
    def check_salt!
      raise NotInitializedError.new(@backend.path.path) if @backend[:system][:salt].blank?
      decrypt(@backend[:system][:salt])
      nil
    end
  end
end
