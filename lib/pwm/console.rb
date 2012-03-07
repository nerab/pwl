require 'highline'

module Pwm
  module Dialog
    class ConsoleBaseDialog < BaseDialog
      def initialize(prompt)
        super(nil, prompt)
        @dialog = HighLine.new(STDIN, STDERR)
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
          STDIN.tty? ? @dialog.ask(prompt){|q| q.echo = "*"} : STDIN.read.chomp
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
