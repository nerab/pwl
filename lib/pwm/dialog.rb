require 'open3'

require 'dialog/base'
require 'dialog/console'
require 'dialog/gnome'
require 'dialog/mac'

module Pwm
  # Wrap the GUI dialog in, factoring out the platform-specific parts
  module Dialog
    class AppNotFoundError < StandardError;end
    class Cancelled < StandardError;end
  end
end
