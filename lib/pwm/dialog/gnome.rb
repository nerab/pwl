module Pwm
  module Dialog
    class GnomeDialog < SystemDialog
      #
      # Returns the OS command that is required to ask the user for a password.
      #
      def command
        "zenity --entry --hide-text --title '#{title}' --text '#{prompt}'"
      end
    end
  end
end
