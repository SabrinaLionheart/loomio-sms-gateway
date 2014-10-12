##
# Command for GetProposal implemented using the new API
class GetProposal < Command
	##
	# Processes a message for GetProposal
	# SMS Usage: getproposal <key>
	def self.process(message)

		# Remove the command name from the message
		message.msg.slice! 0..name.size

		#
		arguments = message.msg


    # Makes API call to LoomioAPI
		result = LoomioAPI.api.getLatestProposalByKey arguments
		
		# If success (the api returns array if successful, otherwise the HTTP error code)
		if result.is_a? Array
      a = result[0]
      d = result[1]
      ab = result[2]
      b = result[3]
      t = a + d + ab + b

      # Sends off a message to the number containing the proposal summary
      return Message.new message.num  %Q(The votes for proposal <#{message.msg}> are
Agree		= #{a}	<#{a/t}>
Disagree	=	#{d} <#{d/t}>
Abstain		=	#{ab} <#{ab/t}>
Block		=	#{b} <#{b/t}>)
    end

    # If unsuccessful, gives error. TODO: Make sure to tidy this up to UX specifications!!
		return Message.new message.num, "Proposal for key \"#{message.msg}\" was not found, error #{result}"

	end
end
