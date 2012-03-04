require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pwm'

class Test::Unit::TestCase
end

module Test
  module Pwm
    class TestCase < Test::Unit::TestCase
      attr_reader :store_file

      def setup
        @store_file = Tempfile.new(self.class.name)
        ::Pwm::Store.init(@store_file.path, store_password, :force => true) 
      end

      def teardown
        @store_file.close
        @store_file.unlink
      end
  
      def store_password
        's3cret'
      end
    end
  end
end
