module Pwl
  module Dialog
    class CocoaDialog < SystemDialog
      #
      # CocoaDialog returns two lines. The first line contains the number of the button, and the second line contains
      # the actual user input. This method amends the base method with handling the two lines.
      #
      def get_input
        result = super.lines.to_a
        result = [] if result.blank?

        case result.size
          when 1 then return_or_cancel(result[0], '')
          when 2 then return_or_cancel(result[0], result[1].chomp)
          else raise "Unknown response from running '#{command}'"
        end
      end

      protected

      #
      # Attempt to find an app within the user's home. If it doesn't exist, an attempt is made to find a system-installed file.
      #
      def local_app_name
        [File.expand_path("~/"), '/'].each{|place|
          local_app = File.join(place, APP_NAME)
          return local_app if File.exist?(local_app) && File.executable?(local_app)
        }
        raise AppNotFoundError.new("Could not find the CocoaDialog app. Maybe it is not installed?")
      end

      #
      # Return the generic command that is common for all dialogs deriving from this class.
      #
      # Derived classes are expected to implement the +type+ method that should return
      #
      def command
        "#{local_app_name} #{type} --title \"#{title}\" --informative-text \"#{prompt}\""
      end

      private
      APP_NAME = "Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"

      def return_or_cancel(statusLine, resultLine)
        status = statusLine.to_i - 1

        if 0 == status
          resultLine
        else
          raise Cancelled.new(status)
        end
      end
    end

    class CocoaTextDialog < CocoaDialog
      def type
        'standard-inputbox'
      end
    end

    class CocoaPasswordDialog < CocoaDialog
      def type
        'secure-standard-inputbox'
      end
    end
  end
end
