module HAPS
  module Server
    module Listeners
      class Base
        def on_connect(connection); raise NotImplementedError; end
        def on_disconnect(connection, data); raise NotImplementedError; end
        def on_data(connection); raise NotImplementedError; end
        def at_exit; end
      end

      autoload :LoggerListener, 'haps/server/listeners/logger_listener'
      autoload :RedisListener, 'haps/server/listeners/redis_listener'
    end
  end
end

