module Pwl
  module Commands
    class Export < Base
      DEFAULT_EXPORT_TEMPLATE = File.join(File.dirname(__FILE__), *%w[.. .. templates export.html.erb])

      def initialize
        super
        command :export do |c|
          c.syntax = "#{program(:name)} #{c.name}"
          c.summary = 'Exports all entries.'
          c.description = 'This command prints all entries to STDOUT.'
          c.example 'Prints all entries', "#{program(:name)} #{c.name}"
          c.option '--format FORMAT', String, 'Specify export format. Default is html.'
          c.example 'Prints all entries in HTML format (default)', "#{program(:name)} #{c.name} --format html"
          c.example 'Prints all entries in JSON format', "#{program(:name)} #{c.name} --format json"
          c.example 'Prints all entries in YAML format', "#{program(:name)} #{c.name} --format yaml"
          c.action do |args, options|
            exit_with(:file_not_found, options.verbose, :file => locker_file) unless File.exists?(locker_file)
            options.default :format => 'html'

            presenter = {:html => Presenter::Html, :json => Presenter::Json, :yaml => Presenter::Yaml}[options.format.to_sym]
            exit_with(:unknown_export_format, options.verbose, :format => options.format) if presenter.nil?

            begin
              locker = Locker.open(locker_file, get_password("Enter the master password for #{program(:name)}:", options.gui))
              puts presenter.new(locker).to_s
            rescue Dialog::Cancelled
              exit_with(:aborted, options.verbose)
            end
          end
        end
      end
    end
  end
end
