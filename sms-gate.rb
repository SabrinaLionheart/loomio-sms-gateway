# This would be replaced to use a different gateway
# This is for the SMS Gateway Android app
require_relative 'message'
require_relative 'parser'
require 'cgi'
require 'uri'
require 'socket'

# Socket to recieve get requests
smsSocket = TCPServer.new "0.0.0.0", 8080
# Parser to parse messages
parser = Parser.new
# Unhelpful message
puts "I'm alive"
loop do
	puts "Listening..."
	# Accept connection
	client = smsSocket.accept
	# Read message
	message = client.recvfrom 1000
	# Respond to client and close connection
	client.puts "K tnx"
	client.close
	# Parse get request
	message = message.first.split
	message = message[1]
	message = message[2..-1]
	message = CGI.parse message
	message = Message.new message["phone"].first, message["text"].first
	# Debug:
	puts message.inspect
	# Parse message
	parser.parse message if message.num && message.msg
	# Send responce from parser goes here
end

