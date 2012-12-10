require 'em-redis'

module HAPS
  module Server
    module Listeners
      class RedisListener < Base
        attr_reader :redis

        def initialize(redis_url = nil)
          @redis = connect redis_url
        end

        def on_connect(connection)
          redis.sadd "haps:connections", connection.name
        end

        def on_disconnect(connection)
          redis.srem "haps:connections", connection.name
        end

        def on_data(connection, data)
        end

        def at_exit
          redis.del "haps:connections"
        end

        private

        # stolen from Resque gem
        def connect(redis_url = nil)
          if redis_url.nil?
            EM::Protocols::Redis.connect
          elsif redis_url['redis://']
            EM::Protocols::Redis.connect :url => server
          else
            server, namespace = server.split('/', 2)
            host, port, db = server.split(':')
            EM::Protocols::Redis.new :host => host, :port => port,
              :db => db
          end
        end
      end
    end
  end
end
