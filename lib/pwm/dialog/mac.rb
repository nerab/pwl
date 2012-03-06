module Pwm
  module Dialog
    class MacOSDialog < SystemDialog
      #
      # CocoaDialog returns two lines. The first line contains the number of the button, and the second line contains
      # the actual user input. This method amends the base method with handling the two lines.
      #
      def get_password
        result = super.split

        if 0 == result[0].to_i - 1
          result[1].chomp
        else
          raise Cancelled.new(result[0].to_i - 1)
        end
      end

      def command
        "#{local_app_name} secure-standard-inputbox --title '#{title}' --informative-text '#{prompt}'"
      end

      private
      APP_NAME = "Applications/CocoaDialog.app/Contents/MacOS/CocoaDialog"

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
    end
  end
end
