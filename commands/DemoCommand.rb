##
# Will not be used, demonstrates implementing a command
class NewPoll < Command
	##
	# Processes a message for newPoll
	# newPoll <Group> <Discussion> <PollName> <PollDescription>
	def self.process(message)
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		# Break the message into 4 arguments
		# This allows the final argument to contain spaces
		# It is not nessicary to do this, most times you shouldn't
		arguments = message.msg.split " ", 4
		# This is where the api call to make the poll would go
		# success = LoomioAPI.createGroup *arguments
		success = false
		
		# This is where the user is told the outcome of their command
		return Message.new message.num, "Your poll has been created" if success
		return Message.new message.num, "Your poll was not created because <reason>.\nThe command is used like this:\nnewPoll <Group> <Discussion> <PollName> <PollDescription>"
	end
end
