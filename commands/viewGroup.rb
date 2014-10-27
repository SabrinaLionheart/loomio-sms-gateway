##
# Will be used to give the user a list of proposals and associated proposal 
# numbers for a given group
class ViewGroup < Command
	##
	# Processes a message for viewGroup
	# viewGroup <subdomain>
	def self.process(message)
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		arguments = message.msg.split " "
		subdomain = arguments.first

		return Message.new message.num, "You have sent the wrong number or arguments. The command usage is:\nViewGroup <Subdomain>" unless arguments.size == 1

		# An API call giving it a subdomain and getting an array of active proposals
		result = LoomioAPI.getProposalsBySubdomain subdomain

		status = result[0]
		# Return this message if the group the user asked for doesn't exist
		return Message.new message.num, "The group does not exist" unless status == 200

		props = result[1]
		msg = "The active proposals are:\n"
		
		# For each hash get the proposal name & key and add it to the msg string
		props.each do |p|
			k = Database.makeFriendly message.num, p["key"]
			n = p["name"]
			msg += "#{k} - #{n}\n"
		end

		# Add help at the end for more information on a proposal
		msg += "Text \"viewProposal\" followed by a proposal number for more info"

		# This is where the user is told the outcome of their command
		return Message.new message.num, msg

	end
end
