class GetSummary < Command
	@name = "getSummary"

	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Outgoing messages go here
		@response = nil
	end
	
	##
	# Continues creating a command
	#
	def ammend(message)
		# nothing here as command requires no params
	end
	
	##
	# Returns true if the command is ready to run
	#
	def ready?
		# always ready to run
		true
	end

	##
	# The payload of the command
	#
	def run
		# Would use loomio api to run command
		puts "Ran: <#{self}>"
		
		# gets user via API
		user = DummyAPI.getUserByNumber(message.num)
	
		# sends back response from API
		@response = Message.new @num, DummyAPI.getSummary user
	end

	def process(message)
		# nothign to process
	end

	##
	# Returns a string representation of the GetSummary command
	def to_s
		"#{self.class.name}"
	end
end
