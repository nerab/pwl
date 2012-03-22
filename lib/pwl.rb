require 'pstore'
require 'encryptor'
require 'active_support/core_ext/object/blank'

$:.unshift File.join(File.dirname(__FILE__), *%w[pwl])

require 'message'
require 'password_policy'
require 'store'
require 'dialog'

module Pwl
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
end
