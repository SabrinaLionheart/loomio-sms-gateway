##
# Will be used to unsubscibe a user from a subdomain
class UnSubscribe < Command
	##
	# Processes a message for unSubscribeFrom
	# unSubscribe <subdomain>
	def self.process(message)
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		subdomain = message.msg

		return Message.new message.num, 
			"You have sent the wrong number of arguments. The command usage is:\n"\
			"UnSubscribe <Subdomain>" if subdomain.empty?

		# An API call unsubscribing the user from a group
		status, response = LoomioAPI.unsubscribeFromSubdomain subdomain, message.num

		# Return this message if the group the user asked for doesn't exist
		return Message.new message.num, "That group does not exist" unless status == 200

		# Return successful message
		return Message.new message.num, "You have been unsubscribed from the group #{subdomain}"
	end
end
