##
# A new discussion has been created and the user is subscribed to it
#
class NewDiscussion < Event
	@name = "new_discussion"

	# Overrides base in Event
	def self.handle(event)
		group = event["group"]
		discussion = event["discussion"]
		username = event["user_name"]
		subscription = event["subscription"]
		# The message
		message = "#{username} started a discussion #{discussion["title"]} in #{group["name"]}:\n"
		message += discussion["description"][0...160-message.length-3 ]
		message += "..." if message.length == 160 - 3
		Message.new subscription["tag"], message
	end
end
