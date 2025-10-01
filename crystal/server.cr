require "http/server"
require "json"

server = HTTP::Server.new do |context|
  if context.request.path == "/hello"
    context.response.content_type = "application/json"
    context.response.print({"message" => "Hello, world!"}.to_json)
  else
    context.response.status_code = 404
  end
end

address = server.bind_tcp "0.0.0.0", 8080
puts "Server running on #{address}"
server.listen
