module Pwl
  module Commands
    class Init < Base
      def initialize
        super
        command :init do |c|
          c.syntax = "#{program(:name)} #{c.name}"
          c.summary = 'Initializes a new locker'
          c.description = 'This command initializes a new password locker. Password quality is enforced using validation rules.'
          c.example "Initializes a new password locker in #{@locker_file}", "#{program(:name)} #{c.name}"
          c.example "Initializes a new password locker in /tmp/crackme.txt", "#{program(:name)} #{c.name} --file /tmp/crackme.txt"
          c.option '--force', 'Force-overwrite an existing locker file'
          c.action do |args, options|
            msg "Attempting to initialize new locker at #{locker_file}" if options.verbose

            # Locker checks this too, but we want to fail fast.
            exit_with(:is_dir, options.verbose, :file => locker_file) if File.exists?(locker_file) && File.directory?(locker_file)
            exit_with(:file_exists, options.verbose, :file => locker_file) if File.exists?(locker_file) && !options.force

            begin
              begin
                master_password = get_password('Enter new master password:', options.gui)
              end while begin
                validate!(master_password) # Basic idea from http://stackoverflow.com/questions/136793/is-there-a-do-while-loop-in-ruby
              rescue Pwl::InvalidMasterPasswordError => e
                msg e.message
                options.gui || STDIN.tty? # only continue the loop when in interactive mode
              end

              # Ask for password confirmation if running in interactive mode (terminal)
              if STDIN.tty? && master_password != get_password('Enter master password again:', options.gui)
                exit_with(:passwords_dont_match, options.verbose)
              end
            rescue Pwl::Dialog::Cancelled
              exit_with(:aborted, options.verbose)
            end

            Pwl::Locker.new(locker_file, master_password, {:force => options.force})
            msg "Successfully initialized new locker at #{locker_file}" if options.verbose
          end
        end
      end
    end
  end
end
