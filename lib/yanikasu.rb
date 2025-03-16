require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

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
        response_body = router.resolve(request)
        response = Response.new(body: response_body)
        response.send(client)
      end
      puts "Client connected!"

      client.close
      puts "Client disconnected."
    end
  end

  def self.load_routers(router) 
    router.add_route("GET", "/hello", ->{"HELLO!"})
    router.add_route("GET", "/json", -> { { message: "Hello, JSON!" } })
  end
end

Yanikasu.start_server
