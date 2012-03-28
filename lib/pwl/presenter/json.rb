require 'jbuilder'

module Pwl
  module Presenter
    class Json
      def initialize(store)
          @store = store
      end

      def to_s
        Jbuilder.encode do |json|
          json.(@store, :created, :last_accessed, :last_modified)

          json.entries @store.all do |json, entry|
            json.key entry.first
            json.value entry.last
          end
        end
      end
    end
  end
end