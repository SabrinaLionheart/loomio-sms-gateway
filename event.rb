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
		# Stores classes for all child events
		attr_accessor :events
	end

	##
	# Keeps track of all events
	#
	# ==== Attributes
	#
	# * +event+ - The class of the event that inherited this class
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
	# ==== Attributes
	#  
	# * +event+ - The event this event has been called to handle
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
