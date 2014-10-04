##
# A new discussion has been created and the user is subscribed to it
#
class NewDiscussion < Event
	@name = "newDiscussion"

	##
	# Creates the message to notify the user of the event
	#
	def self.handle(event)
		msg = "A new discussion called #{event["discussion name"]} has been opened in #{event["group name"]} by #{event["opening user"]}."
		# The message
		Message.new event["number"], msg
	end
end
