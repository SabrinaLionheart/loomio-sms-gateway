class SubscribeTo < Command
	##
	# Makes a command to subscribe a user to a subdomain
	# subscribe <subdomain>
	def self.process(message)

		message.msg.slice! 0..name.size
		arguments = message.msg.split " "	
		subdomain = arguments.first

		return Message.new message.num, "You have sent the wrong number or arguments. The command usage is:\nSubscribeTo <Subdomain>" unless arguments.size == 1

		status, response = LoomioAPI.subscribeToSubdomain subdomain, message.num
		
		msg = "You have been subscribed to the group #{subdomain}"
		# The message
		return Message.new message.num, msg if status == 200
		
		msg = "Sorry, that group does not exist"
		# The message
		return Message.new message.num, msg
	end	
end
