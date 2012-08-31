require 'commander/import'

module Pwl
  module Commands
    EXIT_CODES = {
      :success               => Message.new('Success.'),
      :aborted               => Message.new('Aborted by user.', 1),
      :passwords_dont_match  => ErrorMessage.new('Passwords do not match.', 2),
      :no_value_found        => Message.new('No value found for <%= name %>.', 3, :name => 'NAME'),
      :file_exists           => ErrorMessage.new('There already exists a locker at <%= file %>. Use --force to overwrite it or --file to specify a different locker.', 4, :file => 'FILE'),
      :file_not_found        => ErrorMessage.new('Locker file <%= file %> could not be found.', 5, :file => 'FILE'),
      :name_blank            => ErrorMessage.new('Name may not be blank.', 6),
      :value_blank           => ErrorMessage.new('Value may not be blank.', 7),
      :list_empty            => Message.new('List is empty.', 8),
      :list_empty_filter     => Message.new('No names found that match filter <%= filter %>.', 9, :filter => 'FILTER'),
      :validation_new_failed => ErrorMessage.new('<%= message %>.', 10, :message => 'Validation of new master password failed'),
      :unknown_export_format => ErrorMessage.new('<%= format %> is not a known export format.', 11, :format => 'FORMAT'),
      :inaccessible_field    => ErrorMessage.new("Field '<%= field %>' is not accessible.", 12, :field => 'FIELD'),
      :is_dir                => ErrorMessage.new('File expected, but <%= file %> is a directory. Specify a regular file for the locker.', 13, :file => 'FILE'),
    }

    program :version, VERSION
    program :description, "#{program(:name)} is a secure password locker for the command line."
    program :help, 'Exit Status',  "#{program(:name)} sets the following exit status:\n\n" + EXIT_CODES.values.sort{|l,r| l.exit_code <=> r.exit_code}.collect{|m| "      #{m.exit_code.to_s.rjust(EXIT_CODES.size.to_s.size)}: #{m.to_s}"}.join("\n")
    program :help, 'Author', 'Nicholas E. Rabenau <nerab@gmx.at>'

    global_option '-V', '--verbose', 'Enable verbose output'
    global_option('-f', '--file FILE', 'Determine the file that holds the locker'){|file| locker_file = file}
    global_option '-g', '--gui', 'Request the master password using an OS-specific GUI dialog. This option takes precedence over STDIN.'

    class InacessibleFieldError < StandardError
      def initialize(field)
        super("The field #{field} is not accessible")
      end
    end

    class Base
      def initialize
        @locker_file = File.expand_path("~/.#{program(:name)}.pstore")
      end

    protected

      attr_accessor :locker_file

      def msg(str)
        STDERR.puts("#{program(:name)}: #{str}")
      end

      def exit_with(error_code, verbose, msg_args = {})
        msg = EXIT_CODES[error_code]
        raise "No message defined for error #{error_code}" if !msg

        if msg.error? || verbose # always print errors; messages only when verbose
          msg msg.to_s(msg_args)
        end

        exit(msg.exit_code)
      end

      def get_password(prompt, gui = false)
        (gui ? Pwl::Dialog::Password.new(program(:name), prompt) : Pwl::Dialog::ConsolePasswordDialog.new(prompt)).get_input
      end

      def get_text(prompt, gui = false)
        (gui ? Pwl::Dialog::Text.new(program(:name), prompt) : Pwl::Dialog::ConsoleTextDialog.new(prompt)).get_input
      end

      def validate!(pwd)
        Pwl::Locker.password_policy.validate!(pwd)
      end

      #
      # Returns the value of the passed attribute name if it is allowed to be retrieved from a locker entry
      #
      def attr!(entry, field)
        raise InacessibleFieldError.new(field) unless entry.instance_variable_defined?("@#{field}".to_sym)
        entry.send(field)
      end
    end
  end
end
