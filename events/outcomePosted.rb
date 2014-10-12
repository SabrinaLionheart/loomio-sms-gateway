##
# A new discussion has been created and the user is subscribed to it
#
class PollOutcomePosted < Event
	@name = "motion_outcome_posted"

	##
	# Creates the message to notify the user of the event
	#
	def self.handle(event)
	
		# Making a call to the API giving it a proposal number and getting a proposal 
		proposal = event["motion"]
		username = event["user_name"]
		subscription = event["subscription"]
		# The message
		message = "#{username} posted an outcome for #{proposal["name"]}:\n"
		message += proposal["outcome"][0...160-message.length-3 ]
		message += "..." if message.length == 160 - 3
		Message.new subscription["tag"], message
	end
end
