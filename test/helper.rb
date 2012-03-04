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

    class AppTestCase < TestCase
      APP = 'bin/pwm'

      protected
      
      def assert_successful(expected_out, cmd)
        out, err, rc = execute(cmd)
        assert_equal(0, rc.exitstatus)
        assert(err.empty?)
        assert(out =~ /#{expected_out}/)
      end
  
      def assert_error(expected_err, cmd)
        out, err, rc = execute(cmd)
        assert_equal(1, rc.exitstatus)
        assert(out.empty?)
        assert(err =~ /#{expected_err}/)
      end
  
      def execute(cmd)
        Open3.capture3("#{APP} #{cmd}")
      end
    end
  end
end
