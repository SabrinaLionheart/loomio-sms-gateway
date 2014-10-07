class GetPoll < Command
	@name = "getPoll"

	##
	# Makes a command to get a poll summary for a user
	#
	# pollSummary, group, discussion
	def initialize(message)
		# List of necessary inputs needed for this command
		@args = []
		# Stores number of the message
		@num = message.num
		# Used for outgoing messages
		@response = nil
		# List of discussions for a group
		@disList = nil
		
		# Set ready to false
		@ready = false
		# Set run to false
		@run = false
		
		# Remove command name and store rest as input
		input = message.msg.slice! 0..name.size
		# Process the rest of the input from the message
		input = input.strip
		process input
	end

	##
	# Continue making command with more inputs from a message 
	#
	def ammend(message)
		input = message.msg.strip
		# only process input if it is not empty
		if(input.size > 0)
			process [input]
		else
			@response = Message.new @num, "You have a sent an empty message to the command #{name}."
		end
	end

	##
	# Ready to run when valid 
	#
	def ready?
		return @ready
	end

	##
	# Will run the pollSummary command
	#
	def run
		# Would use loomio api to run command
		puts "Ran: <#{self}>"
		if(run)
			@response = Message.new @num, "You have asked for a poll summary of group:#{@args[0]} and discussion:#{@args[1]}."
		else
			# Do nothing
		end
	end


	##
	# Allocates the correct parsing for an input from a message 
	# and will determine what message will return to the user
	#
	def process(input)
		# Try to parse input that may have been given with initial message
		if(input.size > 0)
			# Clear response
			@response = nil
			
			case @args.size
			when 0
				@response = Message.new @num, parseGroup input
			when 1
				@response = Message.new @num, parseDiscussion input
			else
				$stderr.puts "Error in parsing inputs for #{name}. This command should already be closed. 
					It is now being ignored."
				endCommand(false)
				break
			end
		else
			@response = Message.new @num, "From which group do you want a poll summary from?"
		end
	end

	##
	# Checks the group is valid and adds it to the arguments
	#
	def parseGroup(group)
		# Would use loomio api to verify group
		@args << group
		# Get discussion list for this group using loomio api
		@disList = "String with a list of discussions in this group"

		# Failed responses return
			# "Could not find a group or subdomain using the input #{group}"
			# "#{group} is private. You do not have access to this."
		# endCommand(false)
		
		# Successful response
		return "Reply with either a discussion name or number from this list:\n" + @disList
	end

	##
	# Checks the discussion is valid and adds it to the arguments
	#
	def parseDiscussion(discussion)
		# Would use loomio api to verify discussion
		@args << discussion	

		# Failed response returns
			# "Discussion #{discussion} not found, please use a number or name from this list:\n"
			#		+ @disList

		# Succesful finding discussion, will return poll summary
		return getSummary
	end

	##
	# Get the poll summary using the loomio interface and args
	#
	def getSummary
		# Use args to ask loomio for summary
		summary = "This is a summary from a succesful poll and discussion search"
		
		# Now enable command to run
		@endCommand(true)
		# Return the summary
		return summary
	end

	##
	# Will allow command to run
	def endCommand(valid)
		@ready = true
		@run = valid
	end

end
