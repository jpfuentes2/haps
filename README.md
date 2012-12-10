# Examples

## Client

The client connects to the HAProxy stats socket via the haproxy-ruby gem and pushes the information
to the aggregator server.

```ruby
HAPS::Client.configure do |c|
  c.ssl true
  c.ssl_private_key "certs/cert.key",
  c.ssl_cert_chain "certs/cert.crt"
  c.haproxy_socket "/tmp/haproxy/haproxy.sock"
end

HAPS::Client.start "127.0.0.1", 10001
```

## Server

The server is an event-machine TCP/IP which proxies data to an array of listenters. The listeners below
will push stats/data into redis and log connection info.

```ruby
HAPS::Server.configure do |c|
  c.ssl true
  c.ssl_private_key "certs/cert.key"
  c.ssl_cert_chain "certs/cert.crt"
  c.ssl_verify_peer true

  c.use HAPS::Server::Listeners::LoggerListener, STDOUT
  c.use HAPS::Server::Listeners::RedisListener, ENV['REDIS_URL']
end

HAPS::Server.start "127.0.0.1", 10001
```
