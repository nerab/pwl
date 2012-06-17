module Pwl
  module Presenter
    class Json
      def initialize(locker)
          @locker = locker
      end

      def to_s
        result = {}
        %w[created last_accessed last_modified].each do |attr|
          result.store(attr.to_sym, @locker.send(attr))
        end
        result[:entries] = @locker.all.collect{|e| {:uuid => e.uuid, :name => e.name, :password => e.password}}
        result.to_json
      end
    end
  end
end
