class Response
  attr_accessor :status, :headers, :body

  def initialize(status: '200 OK', headers: {}, body: '')
    @status = status
    @headers = headers
    self.body = body 
  end

  def body=(value)
    @body = value.is_a?(String) ? value : JSON.generate(value)
  end

  def send(client)
    default_headers = {
      "Content-Type" => headers["Content-Type"] || "application/json",
      "Content-Length" => body.bytesize.to_s
    }
    full_headers = default_headers.merge(headers)
  
    response_headers = "HTTP/1.1 #{@status}\r\n"
    full_headers.each { |key, value| response_headers += "#{key}: #{value}\r\n" }
    response_headers += "\r\n"
  
    client.print response_headers
    client.print body
  end  
end