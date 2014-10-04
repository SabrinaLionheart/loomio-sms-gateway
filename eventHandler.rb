# Require all events
require_relative 'event'
Dir[File.dirname(__FILE__) + '/events/*.rb'].each do |file|
	require file
end

##
# Recieves events from Loomio as json objects and
# handles them apropriatly
#
class EventHandler
	def initialize
		# Build events hash
		@events = Event.events.inject Hash.new do |events, event| 
			events[event.name] = event
			events
		end
	end

	##
	# Returns a Sinatra app that recieves events from Loomio as json objects and
	# handles them apropriatly
	#
	def getHandler(array, mutex, conditionNewMessage)
		require 'json'
		require 'sinatra/base'
		events = @events
		handler = Sinatra.new do
			# Configure sinatra
			set :port, 8080
			set :bind, '0.0.0.0'

			post '/' do
				# Will likely change

				# No event?
				event = JSON.parse request.body.read
				return "Need event in body" unless event
				handler = events[event["name"]]
				# Unhandled event?
				return "Event not recognised" unless handler

				message = handler.handle event
				
				mutex.synchronize do
					array << message
					conditionNewMessage.signal
				end
				return "#{event["name"]} processed successfully"
			end
		end
		handler
	end
end
