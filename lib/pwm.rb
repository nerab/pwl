require 'pstore'
require 'encryptor'
require 'active_support/core_ext/object/blank'

require 'pwm/store'

module Pwm
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
end
