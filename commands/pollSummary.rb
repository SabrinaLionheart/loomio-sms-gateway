class pollSummary < Command
	@name = "pollSummary"


	def initialize(message)
		# List of necessary inputs needed for this command
		@args = []
		# Stores number of the message
		@num = message.num
		# Used for outgoing messages
		@response = nil
		# Remove command name and store rest as input
		message.msg.slice! 0..name.size
		# Split message into inputs
		inputs = message.msg.split delimiter
		# Process the rest of the input
		process inputs

	end

	##
	# Continues creating a command
	#
	def ammend(message)
		process [message.msg]
	end

	def ready?
		@args.size == 2
	end

	def run
		# Would use loomio api to run command
		puts "Ran: <#{self}>"

		@response = Message.new @num, "You have asked for a poll summary of group:#{@args[0]} and discussion:#{@args[1]}."
	end


	def process(inputs)

		# Clear response
		@response = nil

		# Strip whitespace
		arguments.map! do |arg|
			arg.strip
		end
		while !inputs.empty?
			case @args.size
			when 0
				@response = parseGroup inputs.shift
			when 1
				@ response = parseDiscussion inputs.shift
			when 2
				@response = getSummary @args
			else
				$stderr.puts "#{name} was passed too many arguments. Ignoring...beware."
				break
			end
		end

		unless @response
			case @args.size
			when 0
				@response = Message.new @num, "What group do you want a poll summary for?"
			when 1
				@response = Message.new @num, "What is the discussion name for the poll you want a summary of?"
			end
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		# Would use loomio api to verify group
		@args << group
		# List of 
	end

	##
	# Checks the discussion is valid and adds it to the arguments
	#
	def parseDiscussion(discussion)
		# Would use loomio api to verify group
		@args << discussion
	end

	def getSummary
		# Use args to ask loomio for summary
		return "This is a summary from a succesful poll and discussion search"
	end
end
