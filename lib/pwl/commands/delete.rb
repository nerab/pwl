module Pwl
  module Commands
    class Delete < Base
      def call(args, options)
        exit_with(:name_blank, options.verbose) if 0 == args.size || args[0].blank?

        begin
          locker = open_locker(options)
        rescue Pwl::Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end

        locker.delete(args[0])
        msg "Successfully deleted the value under #{args[0]}." if options.verbose
      end
    end
  end
end
