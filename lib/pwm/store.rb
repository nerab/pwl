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

      #
      # Constructs a new store (not only the object, but also the file behind it).
      #
      # Store.new(file, master_password, options)
      #   file.exists?
      #     true:
      #       options[:force]
      #         true:
      #           load
      #           reset!
      #         false:
      #           raise FileAlreadyExistsError
      #     no:
      #       load
      #       reset!
      def new(file, master_password, options = {})
        if File.exists?(file) && !options[:force] # don't allow accedidential override of existing file
          raise FileAlreadyExistsError.new(file)
        else
          store = load(file, master_password)
          store.reset!
        end

        store
      end

      #
      # Opens an existing store. Throws if the backing file does not exist or isn't initialized.
      #
      # Store.open(file, master_password)
      #   file.exists?
      #     true:
      #       load
      #       authenticate
      #     false:
      #       raise FileNotFoundError
      #
      def open(file, master_password)
        raise FileNotFoundError.new(file) unless File.exists?(file)
        store = load(file, master_password)
        store.authenticate # do not allow openeing without successful authentication
        store
      end
    end

    #
    # Beware: New is overridden
    #
    def initialize(file, master_password)
      @backend = PStore.new(file, true)
      @backend.ultra_safe = true
      Encryptor.default_options.merge!(:key => master_password)
    end

    def reset!
      @backend.transaction{
        @backend[:user] = {}
        @backend[:system] = {}
        @backend[:system][:created] = DateTime.now
        @backend[:system][:salt] = Random.rand.to_s.encrypt
      }
    end

    def authenticate
      begin
        @backend.transaction(true){
          raise NotInitializedError.new(@backend.path.path) unless @backend[:user] && @backend[:system] && @backend[:system][:created]
          salt
        }
      rescue OpenSSL::Cipher::CipherError
        raise WrongMasterPasswordError
      end
    end

    def get(key)
      raise BlankKeyError if key.blank?
      @backend.transaction{
        timestamp!(:last_accessed)
        value = @backend[:user][key]
        raise KeyNotFoundError.new(key) unless value
        value.decrypt
      }
    end

    def put(key, value)
      raise BlankKeyError if key.blank?
      raise BlankValueError if value.blank?
      @backend.transaction{
        timestamp!(:last_modified)
        @backend[:user][key] = value.encrypt
      }
    end

    def list
      @backend.transaction(true){
        @backend[:user].keys
      }
    end

    def created
      @backend.transaction(true){timestamp(:created)}
    end

    def last_accessed
      @backend.transaction(true){timestamp(:last_accessed)}
    end

    def last_modified
      @backend.transaction(true){timestamp(:last_modified)}
    end

    private
    # must run in an transaction
    def timestamp(sym)
      @backend[:system][sym]
    end

    # must run in an transaction
    def timestamp!(sym)
      @backend[:system][sym] = DateTime.now
    end

    # must run in an transaction
    def salt
      raise NotInitializedError.new(@backend.path.path) if @backend[:system][:salt].blank?
      @backend[:system][:salt].decrypt
    end
  end
end
