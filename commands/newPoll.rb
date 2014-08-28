class NewPoll < Command
	@name = "newPoll"

	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Args go here
		@args = []
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
		@args.size == 4
	end

	##
	# The payload of the command
	#
	def run
		# Would use loomio api to run command
	end

	def process(message)
		arguments = message.msg.split self.class.delimiter
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
				$stderr.puts "#{@name} was passed too many arguments. Ignoring...beware."
				break
			end
		end
		# Would check @arg.size here and ask the user to 
		# send more arguments if nessicary
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
		"#{self.class.name} #{@args.join ', '}"
	end
end
				
	
