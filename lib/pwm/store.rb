module Pwm
  class Store
    def initialize(file, master_password)
      Encryptor.default_options.merge!(:key => master_password)
      @backend = PStore.new(file)
    end
    
    def get(key)
      @backend.transaction(true){@backend[key].decrypt rescue nil}
    end
    
    def put(key, value)
      @backend.transaction(false){@backend[key] = value.encrypt}
    end
  end
end