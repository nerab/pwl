require 'open3'

module Pwm
  module Dialog
    class AppNotFoundError < StandardError;end
    class Cancelled < StandardError;end

    #
    # Base class for dialogs
    #
    class BaseDialog
      attr_reader :title, :prompt

      #
      # Constructs a new dialog with the given title and prompt.
      #
      def initialize(title, prompt)
        @title, @prompt = title, prompt
      end
    end

    #
    # Base class for dialogs implemented by executing a system command.
    #
    class SystemDialog < BaseDialog
      def get_input
        out, err, rc = Open3.capture3(command)
        raise Cancelled.new(rc.exitstatus) unless 0 == rc.exitstatus
        out.chomp
      end

      def command
        raise "Not implemented. A derived class is expected to provide the OS command for prompting a password."
      end
    end
  end
end
