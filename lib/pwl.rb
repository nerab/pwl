require 'pstore'
require 'encryptor'
require 'date'
require 'active_support'

$:.unshift File.join(File.dirname(__FILE__), *%w[pwl])

require 'message'
require 'password_policy'
require 'locker'
require 'entry'
require 'entry_mapper'
require 'dialog'
require 'presenter/html'
require 'presenter/json'
require 'presenter/yaml'

module Pwl
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
end
