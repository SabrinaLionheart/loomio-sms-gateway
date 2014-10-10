class Subscribe < Command
	@name = "subscribe"

	##
	# Makes a command to subscribe a user to a subdomain
	#
	# Needs API functions that add users to a 
	def subscribe(message)
		@group	= subdomain
		@user	= username
		if(api.Sub(user) == success)
			msg = "You have been subscribed to the group " + group
			# The message
			Message.new msg
		else
			msg = “Sorry, that group does not exist”
			# The message
			Message.new msg
	end
	
end