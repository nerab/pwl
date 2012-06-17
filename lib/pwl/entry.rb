require 'active_model'
require 'uuid'

module Pwl
  class InvalidEntryError < StandardError
    def initialize(errors)
      super(errors.to_a.join(', '))
    end
  end

  class Entry
    attr_accessor :uuid, :name, :password

    include ActiveModel::Validations
    validates_presence_of :name, :uuid, :password
    validates_format_of :uuid, :with => /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/

    def initialize(name = nil)
      @name = name
      @uuid = UUID.generate
      @password = nil
    end

    #
    # raises InvalidEntryError if entry is not valid
    #
    def validate!
      raise InvalidEntryError.new(errors) if invalid?
    end
  end
end
