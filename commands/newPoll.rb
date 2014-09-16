class NewPoll < Command
	@name = "newPoll"

	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Args go here
		@args = []
		# Stores message number
		@num = message.num
		# Outgoing messages go here
		@response = nil
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		# Break incoming message into arguments
		arguments = message.msg.split delimiter
		# Parse the message
		process arguments
	end
	
	##
	# Continues creating a command
	#
	def ammend(message)
		process [message.msg]
	end
	
	##
	# Returns true if the command is ready to run
	#
	def ready?
		@args.size == 4
	end

	##
	# The payload of the command
	#
	def run
		# Would use loomio api to run command
		puts "Ran: <#{self}>"
		@response = Message.new @num, "You asked for: <#{self}>"
	end

	def process(arguments)
		# Clear response
		@response = nil
		# Strip whitespace
		arguments.map! do |arg|
			arg.strip
		end
		while !arguments.empty?
			case @args.size
			when 0
				parseGroup arguments.shift
			when 1
				parseDiscussion arguments.shift
			when 2
				parsePollName arguments.shift
			when 3
				parsePollDescription arguments.shift
			else
				$stderr.puts "#{name} was passed too many arguments. Ignoring...beware."
				break
			end
		end
		# Sends an appropriate message back if one was not set by the parse functions
		unless @response
			case @args.size
			when 0
				@response = Message.new @num, "What group is this poll for?"
			when 1
				@response = Message.new @num, "What discussion is this poll for?"
			when 2
				@response = Message.new @num, "What would you like to call this poll?"
			when 3
				@response = Message.new @num, "What is the description for this poll?"
			end
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		# Would use loomio api to verify group
		@args << group
	end

	##
	# Checks the discussion is valid and adds it to the arguments
	#
	def parseDiscussion(discussion)
		# Would use loomio api to verify group
		@args << discussion
	end

	##
	# Checks the poll name is valid and avaliable
	#
	def parsePollName(name)
		# Would use loomio api to validate poll name
		@args << name
	end

	##
	# Checks the poll description is valid
	#
	def parsePollDescription(description)
		# It's probably pretty happy with the description
		@args << description
	end

	##
	# Returns a string representation of the newPoll command
	def to_s
		"#{name} #{@args.join ', '}"
	end
end
				
	
