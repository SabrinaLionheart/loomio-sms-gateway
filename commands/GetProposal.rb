class GetProposal < Command
	
	##
	# Processes a message for newPoll
	# getProposal <Proposal number>
	def self.process(message)
		# Remove the command name from the message
		message.msg.slice! 0..name.size
		
		arguments = message.msg.split " "	
		propNum = arguments.first
		
		# Making a call to the API giving it a proposal number and getting a proposal 
		status, proposal = LoomioAPI.getProposalByKey propNum
		
		return Message.new message.num, "The proposal does not exist" unless status == 200

		percentAgree	=	MessageHelper.percentage proposal["yes_votes_count"], proposal["votes_count"]		
		percentDisagree =	MessageHelper.percentage proposal["no_votes_count"], proposal["votes_count"]
		percentAbstain	=	MessageHelper.percentage proposal["abstain_votes_count"], proposal["votes_count"]
		percentBlock	=	MessageHelper.percentage proposal["block_votes_count"], proposal["votes_count"]
		totalVotes		=	proposal["votes_count"]
		
		# This is where the user is told the outcome of their command
		return Message.new message.num, "The current positions are:
Agree		=	#{percentAgree}
Disagree	=	#{percentDisagree}
Abstain		=	#{percentAbstain}
Block		=	#{percentBlock}
Total number of votes = #{totalVotes}"
	end
end
