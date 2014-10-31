require_relative 'message'
##
# Super class for events
#
class Event
	# The events name
	@name = "Event"
	# All events
	@events = []
	
	class << self
		attr_accessor :events
	end

	##
	# Keeps track of all events
	#
	def self.inherited(event)
		# Force childern to have a name
		event.instance_variable_set :@name, @name
		# Track all events
		@events << event
		$stderr.puts "Added event #{event}"
	end

	##
	# Takes an event and produces a message
	#
	def self.handle(event)
		$stderr.puts "#{self.class} did not overwrite handle"
	end

	##
	# Gets the name of an event
	#
	def self.name
		@name
	end
end
