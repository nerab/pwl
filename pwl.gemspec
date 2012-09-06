# -*- encoding: utf-8 -*-
require File.expand_path('../lib/pwl/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nicholas E. Rabenau"]
  gem.email         = ["nerab@gmx.net"]
  gem.summary       = %Q{Command-line password locker}
  gem.description   = %Q{pwl is a secure password locker for the commandline}
  gem.homepage      = "http://github.com/nerab/pwl"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "pwl"
  gem.require_paths = ["lib"]
  gem.version       = Pwl::VERSION

  gem.add_runtime_dependency 'activesupport', '~> 3.2'
  gem.add_runtime_dependency 'activemodel', '~> 3.2'
  gem.add_runtime_dependency 'encryptor', '~> 1.1'
  gem.add_runtime_dependency 'commander', '~> 4.1'
  gem.add_runtime_dependency 'uuid', '~> 2.3'

  gem.add_development_dependency 'guard-minitest', '~> 0.5'
  gem.add_development_dependency 'guard-bundler', '~> 1.0'
  gem.add_development_dependency 'coolline', '~> 0.3'
  gem.add_development_dependency 'growl'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'simplecov', '~> 0.6', :require => false
  gem.add_development_dependency 'nokogiri-diff', '~> 0.1'
end
