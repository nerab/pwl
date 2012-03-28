require 'erb'

module Pwl
  module Presenter
    class Html
      attr_reader :store # used by the ERB template
      DEFAULT_EXPORT_TEMPLATE = File.join(File.dirname(__FILE__), *%w[.. .. .. templates export.html.erb])

      def initialize(store)
          @store = store
          @template = ERB.new(File.read(DEFAULT_EXPORT_TEMPLATE))
      end

      def to_s
        @template.result(binding)
      end
    end
  end
end