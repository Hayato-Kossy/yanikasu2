require 'socket'
require_relative 'request'

module Yanikasu
  def self.start_server
    puts "Starting server on port 3000..."
    server = TCPServer.new(3000)
    
    loop do
      client = server.accept
      request = Request.new(client)
      if request.method != 'OPTIONS'
        puts "Read request: #{request.method} #{request.path}"
        puts "Headers: #{request.headers}"
        puts "Body: #{request.body}"
        puts "Query: #{request.query}"
      end
      puts "Client connected!"

      client.close
      puts "Client disconnected."
    end
  end
end

Yanikasu.start_server
