module Pwl
  module Commands
    class Add < Base
      def call(args, options)
        exit_with(:file_not_found, options.verbose, :file => locker_file) unless File.exists?(locker_file)
        exit_with(:name_blank, options.verbose) if 0 == args.size || args[0].blank?

        # Ask for the master password _before_ it may be necessary to ask for the value in a terminal
        begin
          locker = Pwl::Locker.open(locker_file, get_password("Enter the master password for #{program(:name)}:", options.gui))
        rescue Pwl::Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end

        value = args[1]

        if !value
          exit_with(:value_blank, options.verbose) unless STDIN.tty? || options.gui

          begin
            value = get_text("Enter value for name '#{args[0]}':", options.gui)
          rescue Pwl::Dialog::Cancelled
            exit_with(:aborted, options.verbose)
          end

          # still blank, even after asking for it?
          if value.blank?
            exit_with(:value_blank, true)
          end
        end

        locker.add(args[0], value)
        msg "Successfully stored new value under #{args[0]}." if options.verbose
      end
    end
  end
end
