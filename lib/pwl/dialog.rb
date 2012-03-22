$:.unshift File.join(File.dirname(__FILE__), *%w[dialog])

require 'base'
require 'console'
require 'gnome'
require 'cocoa'

module Pwl
  module Dialog
    PLATFORM_PASSWORD_DIALOGS = {
      :gnome => GnomePasswordDialog,
      :mac   => CocoaPasswordDialog,
    }

    PLATFORM_TEXT_DIALOGS = {
      :gnome => GnomeTextDialog,
      :mac   => CocoaTextDialog,
    }

    extend self

    class Password
      class << self
        # Factory method that creates a new password dialog that suits the current GUI platform.
        # If no implementation was found for the current platform, a ConsolePasswordDialog is returned.
        def new(title, prompt)
          (PLATFORM_PASSWORD_DIALOGS[Dialog.gui_platform] || ConsolePasswordDialog).new(title, prompt)
        end
      end
    end

    class Text
      class << self
        # Factory method that creates a new text (input) dialog that suits the current GUI platform.
        # If no implementation was found for the current platform, a ConsoleTextDialog is returned.
        def new(title, prompt)
          (PLATFORM_TEXT_DIALOGS[Dialog.gui_platform] || ConsoleTextDialog).new(title, prompt)
        end
      end
    end

    def gui_platform
      if ENV['GDMSESSION']
        :gnome
      elsif RUBY_PLATFORM =~ /darwin/
        :mac
      end
    end
  end
end
