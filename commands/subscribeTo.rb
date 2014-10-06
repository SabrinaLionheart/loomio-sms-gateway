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
				@response = Message.new message.num, "Please provide a group or subdomain name to subscribe to"
			end
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		
		# No group supplied? do nothign
		if(!group) return
		
		# Would use loomio api to verify if group is valid
		
		status = DummyAPI.getGroupStatus(@user)
		
		case status
		
		when 'success'
		
			# then would subscribe to the group 
			groups = DummyAPI.getUserGroups(@user)
			if groups.include? group
				@args << group
			else 
				@response = Message.new @num, "You are not in that group. Please select a group from the following list: #{groups.join ", "}"
			end
			
		when 'private'
			@response = Message.new(@num, "Sorry, that group or subdomain is private")
		when 'invalid'
			@respons = Message.new(@num, "Sorry, that group or subdomain does not exist")
		
		end
	end

	##
	# Returns a string representation of the SubscribeTo command
	def to_s
		"#{self.class.name} #{@args.join ', '}"
	end
end
