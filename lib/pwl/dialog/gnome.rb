module Pwl
  module Dialog
    class GnomeDialog < SystemDialog
      def command
        "zenity --title \"#{title}\""
      end
    end
    
    class GnomePasswordDialog < GnomeDialog
      #
      # Returns the OS command that is required to ask the user for a password.
      #
      def command
        "#{super} --entry --hide-text --text \"#{prompt}\""
      end
    end
    
    class GnomeTextDialog < GnomeDialog
      #
      # Returns the OS command that is required to ask the user for text input.
      #
      def command
        "#{super} --entry --text \"#{prompt}\""
      end
    end
  end
end
