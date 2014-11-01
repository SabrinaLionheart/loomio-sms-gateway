##
# Makes a command to subscribe a user to a subdomain
#
# subscribe <subdomain>
#
class Subscribe < Command
	# Overrides base in Command
	def self.process(message)
		message.msg.slice! 0..name.size
		subdomain = message.msg
		
		return Message.new message.num,
			"You have sent the wrong number of arguments. The command usage is: \n"\
			"Subscribe <Subdomain>" if subdomain.empty?

		status, response = LoomioAPI.subscribeToSubdomain subdomain, message.num
		
		msg = "You have been subscribed to the group #{subdomain}"
		# The message
		return Message.new message.num, msg if status == 200
		
		msg = "Sorry, that group does not exist"
		# The message
		return Message.new message.num, msg
	end	
end
