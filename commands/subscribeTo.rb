class SubscribeTo < Command

	##
	# Makes a command to subscribe a user to a subdomain
	# subscribe <subdomain>
	def self.subscribe(message)
		message.msg.slice! 0..name.size
		group = message.split " "

		msg = "You have been subscribed to the group " + group
		# The message
		return Message.new message.num if api.Subscribe
		
		msg = "Sorry, that group does not exist"
		# The message
		return Message.new message.num api.Subscribe
	end
	
end