require 'socket'
require_relative 'request'
require_relative 'router'

module Yanikasu
  def self.start_server
    puts "Starting server on port 3000..."
    server = TCPServer.new(3000)
    router = Router.new
    load_routers(router)

    loop do
      client = server.accept
      request = Request.new(client)
      if request.method != 'OPTIONS'
        # puts "Read request: #{request.method} #{request.path}"
        # puts "Headers: #{request.headers}"
        # puts "Body: #{request.body}"
        # puts "Query: #{request.query}"

        response_body = router.resolve(request)
        
        response = <<~HTTP_RESPONSE
          HTTP/1.1 200 OK
          Content-Type: text/plain
          Content-Length: #{response_body.bytesize}

          #{response_body}
        HTTP_RESPONSE

        client.print response
      end
      puts "Client connected!"

      client.close
      puts "Client disconnected."
    end
  end

  def self.load_routers(router) 
    router.add_route("GET", "/hello", ->{"HELLO!"})
  end
end

Yanikasu.start_server
