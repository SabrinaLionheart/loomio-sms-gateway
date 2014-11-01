##
# A new poll has been created and the user is subscribed to it
#
class NewMotion < Event
	@name = "new_motion"

	# Overrides base in Event
	def self.handle(event)
		motion = event["motion"]
		username = event["user_name"]
		subscription = event["subscription"]
		# The message
		Message.new subscription["tag"], "#{username} started a proposal #{motion["name"]}."
	end
end
