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
    
    def password_dialog
      PLATFORM_PASSWORD_DIALOGS[gui_platform] || ConsolePasswordDialog
    end

    def text_dialog
      PLATFORM_TEXT_DIALOGS[gui_platform] || ConsoleTextDialog
    end
    
    private
    
    def gui_platform
      if ENV['GDMSESSION']
        :gnome
      elsif RUBY_PLATFORM =~ /darwin/
        :mac
      end
    end
  end
end
