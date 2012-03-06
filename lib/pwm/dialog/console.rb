require 'highline'

module Pwm
  module Dialog
    class ConsoleDialog < BaseDialog
      def initialize(prompt = 'Please enter the master password:')
        super(nil, prompt)
        @dialog = HighLine.new
      end

      def get_password
        begin
          STDIN.tty? ? @dialog.ask(prompt){|q| q.echo = "*"} : STDIN.read.chomp
        rescue Interrupt
          raise Cancelled.new(1)
        end
      end
    end
  end
end
