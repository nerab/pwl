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
require 'tmpdir'

class Test::Unit::TestCase
end

module Test
  module Pwm
    class TestCase < Test::Unit::TestCase
      attr_reader :store, :store_file

      def setup
        @store_file = temp_file_name
        @store = ::Pwm::Store.new(@store_file, store_password)
      end

      def teardown
        File.unlink(@store_file)
      end

      def store_password
        's3cret'
      end

      # Make up a name of a file that does not exist in ENV['TMPDIR'] yet
      def temp_file_name
        begin
          result = File.join(Dir.tmpdir, "#{self.class.name}-#{Random.rand}.pstore")
        end while File.exists?(result)
        result
      end
    end

    class AppTestCase < TestCase
      APP = 'bin/pwm'

      protected

      def assert_successful(expected_out, cmd)
        out, err, rc = execute(cmd)
        assert_equal(0, rc.exitstatus, "Expected exit status 0, but it was #{rc.exitstatus}")
        assert(err.empty?, "Expected empty STDERR, but it yielded #{err}")
        assert(out =~ /#{expected_out}/, "'#{out}' did not match expected response '#{expected_out}'")
      end

      def assert_error(expected_err, cmd)
        out, err, rc = execute(cmd)
        assert_equal(1, rc.exitstatus, "Expected exit status 1, but it was #{rc.exitstatus}")
        assert(out.empty?, "Expected empty STDOUT, but it yielded #{out}")
        assert(err =~ /#{expected_err}/, "'#{err}' did not match expected response '#{expected_err}'")
      end

      def execute(cmd)
        Open3.capture3("echo #{store_password} | #{APP} #{cmd} --file #{store_file}")
      end
    end
  end
end
