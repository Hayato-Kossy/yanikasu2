require 'json'

class Request
  attr_reader :method, :path, :headers, :body, :query

  def initialize(client)
    @client = client
    @method, @path, @headers, @body = parse_request
    @query = parse_query_string
  end

  def parse_request
    request_line = read_request_line
    method, path, _http_version = request_line.split(' ', 3)
    headers = read_headers
    body = read_body(headers)

    [method, path, headers, body]
  end

  def read_request_line
    @client.gets.chomp
  end

  def read_headers
    headers = {}
    while line = @client.gets.chomp
      break if line.empty?
      key, value = line.split(': ')
      headers[key] = value
    end
    headers
  end

  def read_body(headers)
    if headers["Content-Length"]
      body = @client.read(headers["Content-Length"].to_i)
      return JSON.parse(body) rescue body # JSONならパース
    end
    ''
  end  

  def parse_query_string
    query_string = @path.split('?')[1]
    return {} unless query_string 

    query_string.split('&').map { |pair| pair.split("=")}.to_h
  end
end