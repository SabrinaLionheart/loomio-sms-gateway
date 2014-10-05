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
	##
	# Adds event handeling to the gateAPI
	#
	def self.setEventHandler(array, mutex, conditionNewMessage)
		require_relative 'gateAPI'
		require 'json'
		# Build events hash
		events = Event.events.inject Hash.new do |events, event| 
			events[event.name] = event
			events
		end
		# Tell GateAPI to handle events
		GateAPI.post '/api/event/?' do
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
end
