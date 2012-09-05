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

require 'commands/base'
require 'commands/add'
require 'commands/delete'
require 'commands/export'
require 'commands/get'
require 'commands/init'
require 'commands/list'
require 'commands/passwd'
require 'commands/stats'

module Pwl
  VERSION = File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION]))
end
