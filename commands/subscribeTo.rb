class Subscribe < Command
	@name = "subscribe"

	##
	# Makes a command to subscribe a user to a subdomain
	#
	# Needs API functions that add users to a 
	def subscribe(message)
		
		@group	= subdomain
		@user	= username
	end
	
end