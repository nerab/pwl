module Pwl
  module Commands
    class List < Base
      def call(args, options)
        options.default :separator => ' '

        begin
          locker = open_locker(options)

          if !options.long
            result = locker.list(args[0]).join(options.separator)
          else
            matching_names = locker.list(args[0])

            result = "total #{matching_names.size}#{$/}"

            matching_names.each do |name|
              e = locker.get(name)
              result << "#{e.uuid}\t#{e.name}#{$/}"
            end
          end

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
