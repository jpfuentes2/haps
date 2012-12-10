require 'forwardable'

module HAPS
  module Server
    module Listeners
      class LoggerListener < Base
        extend Forwardable

        def_delegators :@logger, :info, :debug, :warn, :error, :fatal

        def initialize(log_path)
          @logger = ::Logger.new log_path
        end

        def on_connect(connection)
          info "#{connection.ip_address} connected"
        end

        def on_disconnect(connection)
          info "#{connection.ip_address} disconnected"
        end

        def on_data(connection, data)
          info "received: #{data}"
        end

        def at_exit
          warn  "Shutting down..."
        end
      end
    end
  end
end

