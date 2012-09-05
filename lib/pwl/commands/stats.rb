module Pwl
  module Commands
    class UnknownFormatError < StandardError; end

    module StatsPresenter
      class Text
        def present(locker)
          puts "Created: #{locker.created}"
          puts "Last accessed: #{locker.last_accessed}"
          puts "Last modified: #{locker.last_modified}"
        end
      end

      class Html
        def present(locker)
          puts "TODO"
        end
      end

      class Json
        def present(locker)
          puts "TODO"
        end
      end

      class Yaml
        def present(locker)
          puts "TODO"
        end
      end
    end

    class Stats < Base
      def call(args, options)
        locker = open_locker(options, get_password("Enter the master password for #{program(:name)}:", options.gui))

        begin
          puts presenter(options.format).present(locker)
        rescue
          exit_with(:unknown_format, options.verbose, :format => options.format)
        end
      end

      private

      def presenter(format)
        if !format || format.is_a?(TrueClass) || 'text' == format
          StatsPresenter::Text.new
        else
          begin
            {:html => StatsPresenter::Html, :json => StatsPresenter::Json, :yaml => StatsPresenter::Yaml}[format.to_sym].new
          rescue
            raise UnknownFormatError.new(format)
          end
        end
      end
    end
  end
end
