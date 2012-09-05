module Pwl
  module Commands
    class Export < Base
      DEFAULT_EXPORT_TEMPLATE = File.join(File.dirname(__FILE__), *%w[.. .. templates export.html.erb])

      def call(args, options)
        options.default :format => 'html'

        # TODO See Stats for slightly changed approach using a method
        presenter = {:html => Presenter::Html, :json => Presenter::Json, :yaml => Presenter::Yaml}[options.format.to_sym]
        exit_with(:unknown_export_format, options.verbose, :format => options.format) if presenter.nil?

        begin
          locker = open_locker(options)
          puts presenter.new(locker).to_s
        rescue Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end
      end
    end
  end
end
