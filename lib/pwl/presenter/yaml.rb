require 'yaml'

module Pwl
  module Presenter
    class Yaml
      def initialize(store)
          @store = store
      end

      def to_s
        result = {}
        result[:created] = @store.created.to_s
        result[:last_accessed] = @store.last_accessed.to_s
        result[:last_modified] = @store.last_modified.to_s
        result[:entries] = []
        @store.all.each{|entry|
          result[:entries] << {:key => entry.first, :value => entry.last}
        }
        result.to_yaml
      end
    end
  end
end