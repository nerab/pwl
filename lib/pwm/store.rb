require 'date'

module Pwm
  class Store
    class AlreadyExistsError < StandardError
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
    
    #
    # We need ensure the store is always opened with the right password. But how can we prevent brute-force attacks?
    # Maybe we could have a test entry that is encrypted at init time. The test for the correct password would then be that we can successfully
    # decrypt that key. The creation date seems right, maybe plus some salt so that we don't give both the encrypted as well as the unencrypted
    # value away. Prereq is that decrypt tells whether it failed to decrypt some value if the password was wrong.
    #
    class << self
      def init(file, master_password, options = {})
        raise AlreadyExistsError.new(file) if File.exists?(file) && !options[:force] # force is mainly required for tests, but may be useful in the app, too
        Encryptor.default_options.merge!(:key => master_password)
        backend = PStore.new(file)
        backend.transaction{
          backend[:user] = {} 
          backend[:system] = {}
          backend[:system][:created] = "#{Random.rand}-#{DateTime.now.to_s}".encrypt
        }
      end
      
      def initialized?(file)
        raise FileNotFoundError.new(file) unless File.exists?(file)
        backend = PStore.new(file)
        backend.transaction(true){
          backend[:user] && backend[:system] 
        }
      end
    end
    
    def initialize(file, master_password)
      raise NotInitializedError.new(file) unless Store.initialized?(file)
      Encryptor.default_options.merge!(:key => master_password)
      @backend = PStore.new(file)
      
      begin
        @backend.transaction(true){@backend[:system][:created]}.decrypt
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
    
    def last_accessed
      @backend.transaction(true){timestamp(:last_accessed)}
    end
    
    def last_modified
      @backend.transaction(true){timestamp(:last_modified)}
    end
    
    private
    def timestamp(sym)
      @backend[:system][sym]
    end
    
    def timestamp!(sym)
      @backend[:system][sym] = DateTime.now
    end
  end
end