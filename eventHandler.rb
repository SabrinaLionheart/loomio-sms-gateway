##
# Recieves events from Loomio as json objects and
# handles them apropriatly
#
class EventHandler
	def initilize
		# Build events hash
		@events = Event.events.inject Hash.new { |events, event| events[event.name] = event }
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

		handler = Sinatra.new do
			# Configure sinatra
			set :port, 1234
			set :bind, '0.0.0.0'

			post '/' do
				# Will likely change
				return "Need event parameter" unless params[:event]
				event = JSON.parse params[:event]
				message = @events[event["name"]].handle event

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
