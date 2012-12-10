require 'haproxy'
require 'openssl'

module HAPS
  module Client
    extend Configurable
    extend self

    configure do
      option :ssl, false
      option :ssl_private_key, ""
      option :ssl_cert_chain, ""
      option :update_interval, 2
      option :haproxy_socket, ""
    end

    def self.start(host, port)
      client = Connection.new host, port

      loop do
        client.update_server
        sleep update_interval
      end
    end

    class Connection

      def initialize(host, port)
        @haproxy = HAProxy.read_stats Client.haproxy_socket
        @socket = TCPSocket.open host, port
        configure_ssl! if Client.ssl
      end

      def update_server
        backend = @haproxy.servers.find {|s| s[:pxname] == "sinatra" }
        @socket.puts backend
      end

      private

      def configure_ssl!
        ssl_context = OpenSSL::SSL::SSLContext.new
        ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(Client.ssl_cert_chain))
        ssl_context.key = OpenSSL::PKey::RSA.new(File.open(Client.ssl_private_key))
        ssl_context.ssl_version = :SSLv23

        @socket = OpenSSL::SSL::SSLSocket.new @socket, ssl_context
        @socket.sync_close = true
        @socket.connect
      end
    end
  end
end
