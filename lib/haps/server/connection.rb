module HAPS
  module Server
    class Connection < EM::Connection

      def post_init
        setup_ssl if Server.ssl
        trigger :on_connect
      end

      def ssl_handshake_completed
        Server.log "ssl_handshake_completed"
      end

      def receive_data(data)
        trigger :on_data, data
      end

      def unbind
        trigger :on_disconnect
      end

      def ip_address
        @ip_address ||= Socket.unpack_sockaddr_in(get_peername).last
      end
      alias :name :ip_address

      private

      def setup_ssl
        ssl_options = Server.ssl_options
        options = {
          :private_key_file => ssl_options[:ssl_private_key],
          :cert_chain_file => ssl_options[:ssl_cert_chain],
          :verify_peer => ssl_options[:ssl_verify_peer]
        }
        Server.log options
        start_tls options
      end

      def trigger(event, *args)
        Server.listeners.each do |listener|
          listener.send event, self, *args
        end
      end

    end
  end
end
