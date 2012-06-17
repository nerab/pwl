require 'json'

module Pwl
  #
  # DataMapper that maps an Entry from and to JSON
  #
  class EntryMapper
    class << self
      ATTRIBUTES = %w[uuid name password]
      def from_json(str)
        json = JSON(str, :symbolize_names => true)

        Entry.new.tap do |entry|
          ATTRIBUTES.each do |attr|
            entry.send("#{attr}=", json[attr.to_sym])
          end
        end
      end

      def to_json(entry)
        entry.validate!
        result = {}
        ATTRIBUTES.each do |attr|
          result.store(attr.to_sym, entry.send(attr))
        end
        result.to_json
      end
    end
  end
end
