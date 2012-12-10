require 'eventmachine'
require 'haps/server/connection'

module HAPS
  module Server
    autoload :Listeners, 'haps/server/listeners'

    extend self
    extend Configurable

    configure do
      option :listeners, []
      option :ssl, false
      option :ssl_private_key, ""
      option :ssl_cert_chain, ""
      option :ssl_verify_peer, true
    end

    def start(host, port)
      EM.run do
        log "Listening on #{host}:#{port}"

        listeners.map! { |listener, *args| listener.send :new, *args }
        at_exit { listeners.each &:at_exit }

        EM.start_server host, port, Connection
      end
    end

    def log(line)
      logger.info line
    end

    def logger
      @logger ||= Logger.new STDOUT
    end

    def ssl_options
      { :ssl_private_key => ssl_private_key, :ssl_cert_chain => ssl_cert_chain,
        :ssl_verify_peer => ssl_verify_peer }
    end

    def use(listener, *args)
      listeners << [listener, *args]
    end
  end

end
