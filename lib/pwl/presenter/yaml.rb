require 'yaml'

module Pwl
  module Presenter
    class Yaml
      def initialize(locker)
          @locker = locker
      end

      def to_s
        result = {}
        result[:created] = @locker.created.to_s
        result[:last_accessed] = @locker.last_accessed.to_s
        result[:last_modified] = @locker.last_modified.to_s
        result[:entries] = []
        @locker.all.each do |entry|
          result[:entries] << {
            :uuid => entry.uuid,
            :key => entry.name,
            :value => entry.password
          }
        end
        result.to_yaml
      end
    end
  end
end
