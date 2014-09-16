# This would be replaced to use a different gateway
# This is for the SMS Gateway Android app
# This should never be deployed because it's bad, so is the phone.
require_relative 'message'
require_relative 'parser'
require 'cgi'
require 'net/http'
require 'socket'
require 'uri'

if ARGV.size != 2
	puts "Bad arguments!\nruby sms-gate.rb <server address> <password>"
	exit -1
end
smsServer = ARGV[0]
pass = ARGV[1]
# Socket to recieve get requests
smsSocket = TCPServer.new "0.0.0.0", 8080
# Parser to parse messages
parser = Parser.new 5
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
	reply = parser.parse message if message.num && message.msg
	# Send response if present
	if reply
		begin
			# Make almost correct get request, escape it and 
			# store it as a URI
			url = URI.parse URI.escape("http://#{smsServer}:9090/sendsms?phone=#{reply.num}&text=#{reply.msg}&password=#{pass}")
			# Make the URI a get request proper
			req = Net::HTTP::Get.new url.to_s
			# Do the request
			res = Net::HTTP.start url.host, url.port do |http|
				http.request req
			end
			# Profit
			puts "Sent #{reply.inspect}"
		rescue
			# Do not profit
			puts "Phone is misbehaving again..."
		end
	end
end

