module Pwl
  module Commands
    class Delete < Base
      def call(args, options)
        exit_with(:file_not_found, options.verbose, :file => locker_file) unless File.exists?(locker_file)
        exit_with(:name_blank, options.verbose) if 0 == args.size || args[0].blank?

        begin
          locker = Pwl::Locker.open(locker_file, get_password("Enter the master password for #{program(:name)}:", options.gui))
        rescue Pwl::Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end

        locker.delete(args[0])
        msg "Successfully deleted the value under #{args[0]}." if options.verbose
      end
    end
  end
end
