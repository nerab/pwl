require 'simplecov'
SimpleCov.start

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
require 'pwl'
require 'tmpdir'
require 'active_support/testing/assertions'

class Test::Unit::TestCase
  FIXTURES_DIR = File.join(File.dirname(__FILE__), 'fixtures')
  include ActiveSupport::Testing::Assertions
end

module Test
  module Pwl
    class TestCase < Test::Unit::TestCase
      attr_reader :locker, :locker_file

      def setup
        @locker_file = temp_file_name
        @locker = ::Pwl::Locker.new(@locker_file, locker_password)
      end

      def teardown
        File.unlink(@locker_file)
      end

      def locker_password
        's3cret passw0rd'
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
      APP = 'bin/pwl'

      protected

      def assert_successful(expected_out, cmd, password = locker_password)
        out, err, rc = execute(cmd, password)
        assert_equal(0, rc.exitstatus, "Expected exit status 0, but it was #{rc.exitstatus}. STDERR was: #{err}. Command was '#{cmd}''")
        assert(err.empty?, "Expected empty STDERR, but it yielded #{err}")
        assert(out =~ /#{expected_out}/, "'#{out}' did not match expected response '#{expected_out}'")
      end

      def assert_error(expected_err, cmd, password = locker_password)
        out, err, rc = execute(cmd, password)
        assert_not_equal(0, rc.exitstatus, "Expected non-zero exit status, but it was #{rc.exitstatus}. STDOUT was: #{out}")
        assert(out.empty?, "Expected empty STDOUT, but it yielded #{out}")
        assert(err =~ /#{expected_err}/, "'#{err}' did not match expected response '#{expected_err}'")
      end

      def execute(cmd, password)
        Open3.capture3("echo \"#{password}\" | #{APP} #{cmd} --file \"#{locker_file}\"")
      end

      def fixture(name)
        File.read(File.join(FIXTURES_DIR, name))
      end
    end
  end
end
