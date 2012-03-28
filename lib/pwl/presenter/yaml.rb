require 'yaml'

module Pwl
  module Presenter
    class Yaml
      def initialize(store)
          @store = store
      end

      def to_s
        @store.all.to_yaml
      end
    end
  end
end