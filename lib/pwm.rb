require 'pstore'

module Pwm
  class Store
    def initialize(file, master_password)
      @master_password = master_password
      @backend = PStore.new(file)
    end
    
    def get(key)
      @backend.transaction(true){@backend[key]}
    end
    
    def put(key, value)
      @backend.transaction(false){@backend[key] = value}
    end
  end
end