module Pwl
  module Commands
    class List < Base
      def initialize
        super
        command :list do |c|
          c.syntax = "#{program(:name)} #{c.name} [FILTER]"
          c.summary = 'Lists all names with optional FILTER.'
          c.description = 'This command prints all names to STDOUT. If present, only those names matching FILTER will be returned.'
          c.example 'Prints all names', "#{program(:name)} #{c.name}"
          c.example 'Prints all names which start with "foo"', "#{program(:name)} #{c.name} foo"
          c.example 'Prints all names separated by comma', "#{program(:name)} #{c.name} --separator ,"
          c.option '-s', '--separator SEPARATOR', String, 'Separate names by SEPARATOR'
          c.action do |args, options|
            # Locker checks this too, but we want to fail fast and provide a message.
            exit_with(:file_not_found, options.verbose, :file => locker_file) unless File.exists?(locker_file)

            options.default :separator => ' '

            begin
              result = Locker.open(locker_file, get_password("Enter the master password for #{program(:name)}:", options.gui)).list(args[0]).join(options.separator)
              if !result.blank?
                puts result
              else
                if args[0] # filter given
                  exit_with(:list_empty_filter, options.verbose, args[0])
                else
                  exit_with(:list_empty, options.verbose)
                end
              end
            rescue Dialog::Cancelled
              exit_with(:aborted, options.verbose)
            end
          end
        end
      end
    end
  end
end
