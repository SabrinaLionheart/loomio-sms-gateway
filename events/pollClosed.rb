##
# A new discussion has been created and the user is subscribed to it
#
class PollClosed < Event
	@name = "motion_closed"

	# Overrides base in Event
	def self.handle(event)
	
		# Making a call to the API giving it a proposal number and getting a proposal 
		proposal = event["motion"]
		subscription = event["subscription"]

		percentAgree	=	MessageHelper.percentage proposal["yes_votes_count"], proposal["votes_count"]		
		percentDisagree =	MessageHelper.percentage proposal["no_votes_count"], proposal["votes_count"]
		percentAbstain	=	MessageHelper.percentage proposal["abstain_votes_count"], proposal["votes_count"]
		percentBlock	=	MessageHelper.percentage proposal["block_votes_count"], proposal["votes_count"]
		totalVotes		=	proposal["votes_count"]
	
		Message.new subscription["tag"], 
			"Proposal #{proposal["name"]} has closed. The final positions are:\n"\
			"Agree		=	#{percentAgree}%\n"\
			"Disagree	=	#{percentDisagree}%\n"\
			"Abstain	=	#{percentAbstain}%\n"\
			"Block		=	#{percentBlock}%\n"\
			"Total number of votes = #{totalVotes}"
	end
end
