require 'highline'

module Pwm
  module Dialog
    class ConsoleBaseDialog < BaseDialog
      def initialize(prompt)
        super(nil, prompt)
        @dialog = HighLine.new
      end
      
      protected
      attr_reader :dialog
    end
    
    class ConsolePasswordDialog < ConsoleBaseDialog
      def initialize(prompt = 'Please enter the master password:')
        super(prompt)
      end

      def get_input
        begin
          if STDIN.tty? && STDOUT.tty?             # read from regular console input, print to regular console output
            @dialog.ask(prompt){|q| q.echo = "*"}
          elsif !STDIN.tty? && STDOUT.tty?         # read from pipe, print to regular console output
            STDERR.puts(prompt)
            STDIN.read.chomp
          elsif STDIN.tty? && !STDOUT.tty?         # read from regular console input, print to pipe
            STDERR.print(prompt)
            result = @dialog.ask(''){|q| q.echo = ''}
            STDERR.puts
            result
          else # !STDIN.tty? && !STDOUT.tty?       # read from pipe, print to pipe
            STDIN.read.chomp
          end
        rescue Interrupt
          raise Cancelled.new(1)
        end
      end
    end
    
    class ConsoleTextDialog < ConsoleBaseDialog
      def get_input
        begin
          STDIN.tty? ? @dialog.ask(prompt) : STDIN.read.chomp
        rescue Interrupt
          raise Cancelled.new(1)
        end
      end
    end
  end
end
