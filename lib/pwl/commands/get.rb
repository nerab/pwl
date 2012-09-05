module Pwl
  module Commands
    class Get < Base
      def call(args, options)
        # Locker checks this too, but we want to fail fast and provide a message.
        exit_with(:file_not_found, options.verbose, :file => locker_file) unless File.exists?(locker_file)
        exit_with(:name_blank, options.verbose) if 0 == args.size || args[0].blank?

        # second argument can be a field other than password
        field = args.size > 1 ? args[1] : 'password'

        begin
          locker = Locker.open(locker_file, get_password("Enter the master password for #{program(:name)}:", options.gui))
          result = attr!(locker.get(args[0]), field)
          if result.blank?
            exit_with(:no_value_found, options.verbose, :name => args[0])
          else
            puts result
          end
        rescue InacessibleFieldError
          exit_with(:inaccessible_field, options.verbose, :field => field)
        rescue Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end
      end
    end
  end
end
