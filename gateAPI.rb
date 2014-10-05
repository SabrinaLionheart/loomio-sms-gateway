##
# Co-ordinates use of Sinatra to recieve API calls
#
class GateAPI
	require 'sinatra/base'
	require 'thread'

	##
	# Base sinatra app
	#
	@api = Sinatra.new do
		set :port, 8080
		set :bind, '0.0.0.0'
	end

	##
	# Instance of app
	# Can only have one running at a given time
	#
	@instance = Thread.new do
		@api.run!
	end

	##
	# Provide acess to instance
	#
	class << self
		attr_accessor :api, :instance
	end
end
