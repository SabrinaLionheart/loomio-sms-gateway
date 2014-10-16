##
# Will be used to unsubscibe a user from a sub domain
class unSubscribeFrom < Command
	##
	# Processes a message for unSubscribeFrom
	# unSubscribeFrom <subdomain>
	def self.process(message)
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		arguments = message.msg.split " "
		subdomain = arguments.first

		# An API call unsubscribing the user from a group
		status, response = LoomioAPI.unsubscribeFromSubdomain subdomain, message.num

		# Return this message if the group the user asked for doesn't exist
		return Message.new message.num, "That group does not exist" unless status == 200

		# Return successful message
		return Message.new message.num, "You have been unsubscribed from the group #{subdomain}"

	end
end