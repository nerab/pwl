require 'pstore'
require 'encryptor'
require 'active_support/core_ext/object/blank'

$:.unshift File.join(File.dirname(__FILE__), *%w[pwm])

require 'store'
require 'base_dialog'
require 'console'
require 'gnome'
require 'mac'

module Pwm
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
    
  module Dialog
    PLATFORM_PASSWORD_DIALOGS = {
      :gnome => GnomePasswordDialog,
      :mac   => MacOSPasswordDialog,
    }

    PLATFORM_TEXT_DIALOGS = {
      :gnome => GnomeTextDialog,
      :mac   => MacOSTextDialog,
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
