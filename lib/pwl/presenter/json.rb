require 'jbuilder'

module Pwl
  module Presenter
    class Json
      def initialize(locker)
          @locker = locker
      end

      def to_s
        Jbuilder.encode do |json|
          json.(@locker, :created, :last_accessed, :last_modified)

          json.entries @locker.all do |json, entry|
            json.key entry.first
            json.value entry.last
          end
        end
      end
    end
  end
end