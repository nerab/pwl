module Pwl
  module Commands
    class Passwd < Base
      def call(args, options)
        begin
          locker = open_locker(options)

          if !STDIN.tty? && !options.gui
            # If we are in a pipe and do not run in GUI mode, we accept the new master password as args[0]
            new_master_password = args[0]

            begin
              validate!(new_master_password)
            rescue Pwl::InvalidMasterPasswordError => e
              exit_with(:validation_new_failed, options.verbose, :message => e.message)
            end
          else
            # If running interactively (console or gui), we loop until we get a valid password or break
            begin
              new_master_password = get_password("Enter the new master password for #{program(:name)}:", options.gui)
            end while begin
              validate!(new_master_password)
            rescue Pwl::InvalidMasterPasswordError => e
              msg e.message
              options.gui || STDIN.tty? # only continue the loop when in interactive mode
            end

            # Confirm new password
            if new_master_password != get_password("Enter the new master password for #{program(:name)} again:", options.gui)
              exit_with(:passwords_dont_match, options.verbose)
            end
          end
        rescue Pwl::Dialog::Cancelled
          exit_with(:aborted, options.verbose)
        end

        locker.change_password!(new_master_password)
        msg "Successfully changed master password for #{program(:name)}." if options.verbose
      end
    end
  end
end
