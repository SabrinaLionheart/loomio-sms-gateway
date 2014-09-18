class SuscribeTo < Command
	@name = "suscribeTo"

	
	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Args go here
		@args = []
		# Outgoing messages go here
		@response = nil
		
		#Changed delimiter for this to : allowing different group names
		@delimiter = ':'
		
		# Remove the command name from the message
		message.msg.slice! 0..self.class.name.size
		# Parse the message
		process message
	end
	
	##
	# Continues creating a command
	#
	def ammend(message)
		process message
	end
	
	##
	# Returns true if the command is ready to run
	#
	def ready?
		@args.size == 1
		
	end

	##
	# The payload of the command
	#
	def run
		# Would use loomio api to run command
		puts "Ran: <#{self}>"
		@response = Message.new @num, "Your number #{@num} have now suscribed to the group #{@args[1]}"
	end

	def process(message)
		# Store number
		@num = message.num
		@user = DummyAPI.getUserByNumber message.num
		# Clear response
		@response = nil
		# Break incoming message into arguments
		arguments = message.msg.split delimiter
		# Strip whitespace
		arguments.map! do |arg|
			arg.strip
		end
		
		while !arguments.empty?
			case @args.size
			when 0
				parseGroup arguments.shift
			else
				$stderr.puts "#{@name} was passed too many arguments. Ignoring...beware."
				break
			end
		end
		# Sends an appropriate message back if one was not set by the parse functions
		unless @response
			case @args.size
			when 0
				@response = Message.new message.num, "What group would you like to suscribed to?"
			end
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		# Would use loomio api to verify if group is valid
		# then would suscribe to the group 
		
		if DummyAPI.getUserGroup(@user).include? group
			@args << group
		else 
			@response = "The user is not in the given group"
		end
	end

	##
	# Returns a string representation of the SuscribeTo command
	def to_s
		"#{self.class.name} #{@args.join ', '}"
	end
end
