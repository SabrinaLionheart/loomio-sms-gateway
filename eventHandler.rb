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
	# Recieves events from Loomio as json objects and
	# handles them apropriatly
	#
	# Expects to be run in it's own Thread
	#
	def handleEvents(array, mutex, conditionNewMessage)
		require 'json'
		require 'sinatra/base'
		events = @events
		handler = Sinatra.new do
			# Configure sinatra
			set :port, 1234
			set :bind, '0.0.0.0'

			post '/' do
				# Will likely change

				# No event?
				puts params.inspect
				event = JSON.parse params[:event]
				puts events.inspect
				return "Need event" unless event
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
		$stderr.puts "Started event handler"
		handler.run!
		# Sinatra will likely trap ctrl_c here, this is a work around
		# TODO: Fix this
		exit 0
	end
end
