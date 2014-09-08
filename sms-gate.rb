require_relative 'message'
require_relative 'parser'
require 'cgi'
require 'uri'
require 'socket'

smsSocket = TCPServer.new "0.0.0.0", 8080
parser = Parser.new
puts "I'm alive"
loop do
	puts "Listening..."
	client = smsSocket.accept
	message = client.recvfrom 1000
	client.puts "K tnx"
	client.close
	message = message.first.split
	message = message[1]
	message = message[2..-1]
	message = CGI.parse message
	message = Message.new message["phone"].first, message["text"].first
	puts message.inspect
	parser.parse message if message.num && message.msg
end

