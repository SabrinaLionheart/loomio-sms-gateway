class SubscribeTo < Command
	@name = "subscribeTo"
	#Changed delimiter for this to : allowing different group names
	@delimiter = ':'

	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Args go here
		@args = []
		# Outgoing messages go here
		@response = nil
		
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
		
		DummyAPI.subscribeToGroup @user, @args[0]
		
		@response = Message.new @num, "You (#{@num}) have been subscribed to the group #{@args[0]}."
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
				@response = Message.new message.num, "What group would you like to be subscribed to?"
			end
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		# Would use loomio api to verify if group is valid
		# then would subscribe to the group 
		groups = DummyAPI.getUserGroups(@user)
		if groups.include? group
			@args << group
		else 
			@response = Message.new @num, "You are not in that group. Your options are #{groups.join ", "}"
		end
	end

	##
	# Returns a string representation of the SubscribeTo command
	def to_s
		"#{self.class.name} #{@args.join ', '}"
	end
end
