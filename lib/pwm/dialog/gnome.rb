module Pwm
  module Dialog
    class GnomePasswordDialog < SystemDialog
      #
      # Returns the OS command that is required to ask the user for a password.
      #
      def command
        "zenity --entry --hide-text --title '#{title}' --text '#{prompt}'"
      end
    end
    
    class GnomeTextDialog < SystemDialog
      #
      # Returns the OS command that is required to ask the user for text input.
      #
      def command
        "zenity --entry --title '#{title}' --text '#{prompt}'"
      end
    end
  end
end
