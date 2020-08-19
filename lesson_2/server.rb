require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ")
  path, params = path_and_params.split("?")

  params = params.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  http_method, path, params = parse_request(request_line)

  # TODO: Prepend with `client` object, e.g., `client.puts`
  puts "HTTP/1.0 200 OK"
  puts "Content-Type: text/html"
  puts
  puts "<html>"
  puts "<body>"
  puts "<pre>"
  puts http_method
  puts path
  puts params
  puts "</pre>"

  puts "<h1>Rolls!</h1>"
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  rolls.times do
    roll = rand(sides) + 1
    puts "<p>", roll, "</p>"
  end

  puts "</body>"
  puts "</html>"
  client.close
end
