class SubscribeTo < Command
	##
	# Makes a command to subscribe a user to a subdomain
	# subscribe <subdomain>
	def self.process(message)

		message.msg.slice! 0..name.size
		arguments = message.msg.split " "	
		subdomain = arguments.first
		
		msg = "You have been subscribed to the group #{subdomain}"
		# The message
		return Message.new message.num, msg if LoomioAPI.subscribe subdomain
		
		msg = "Sorry, that group does not exist"
		# The message
		return Message.new message.num, msg
	end	
end