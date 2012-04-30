require 'pstore'
require 'encryptor'
require 'active_support'

$:.unshift File.join(File.dirname(__FILE__), *%w[pwl])

require 'message'
require 'password_policy'
require 'store'
require 'dialog'
require 'presenter/html'
require 'presenter/json'
require 'presenter/yaml'

module Pwl
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
end
