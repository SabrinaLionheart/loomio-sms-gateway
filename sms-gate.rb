require_relative 'message'
require_relative 'parser'
require 'net/http'
require 'sinatra'

# Arguments
if ARGV.size !=2
	puts "Bad arguments!\nruby sms-gate.rb <server address> <password>"
	exit -1
end
server = ARGV[0]
pass = ARGV[1]

# New parser with ~5 minutes of timeout on messages
parser = Parser.new 5

# Tell sinatra to use port 8080
set :port, 8080

# Tell sinatra to do the work
get '/' do
	# Make sure the required parameters are present
	# Report when they are missing
	return "Need parameter phone" unless params[:phone]
	return "Need parameter text" unless params[:text]

	# Process the message
	reply = parser.parse Message.new params[:phone], params[:text]

	# Send the reply
	if reply
		# Build the url
		url = URI.parse URI.escape("http://#{server}:9090/sendsms?phone=#{reply.num}&text=#{reply.msg}&password=#{pass}")
		# Attempt to send message
		resp = Net::HTTP.get_response(url)
		# Sucess
		return resp.body if resp.is_a?(Net::HTTPSuccess)
		# Else failure
		return "Failed to send message!"
	end
end
