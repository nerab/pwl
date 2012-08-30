require 'drb'
require 'active_support/core_ext/numeric/time'

module Pwl
  class InvalidSessionError < StandardError
    def initialize(sid)
      super("Session #{sid} is not valid.")
    end
  end

  class Session
    attr_reader :id

    def initialize(lifetime = 600)
      @lifetime = lifetime
      @id = %x[uuidgen].chomp
      touch
    end

    def touch
      @valid_until = @lifetime.seconds.from_now
    end

    def valid?
      Time.now <= @valid_until
    end
  end

  class Server
    def initialize(store_file)
      @sessions = {}
      @store_file = store_file
    end

    def login(password)
      @locker = Pwl::Locker.open(@store_file, password)
      session = Session.new
      @sessions[session.id] = session
      session.id
    end

    def locker(session_id)
      $stderr.puts "#{DateTime.now} - Access with '#{session_id}'"
      raise InvalidSessionError.new(session_id) unless @sessions[session_id] && @sessions[session_id].valid?
      @sessions[session_id].touch
      @locker
    end
  end
end
