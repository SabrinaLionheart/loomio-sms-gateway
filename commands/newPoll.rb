class NewPoll < Command
	@name = "newPoll"

	##
	# Makes a command to create a new poll
	#
	# newPoll group, discussion, poll_name, poll_description
	def initialize(message)
		# Remove the command name from the message
		message.msg.slice! @name
		# Parse the message
		process message
	end

	def process(message)
		arguments = message.msg.split @delimiter
		while !arguments.empty?
			case @position
			when 0
				parseGroup arguments.shift
			when 1
				parseDiscussion arguments.shift
			when 2
				parsePollName arguments.shift
			when 3
				parsePollDescription arguments.shift
			else
				$stderr.puts "#{@name} command at bad position (#{@position}) ignoring...beware."
				arguments = []
			end
		end
	end
end
				
	
