##
# A new discussion has been created and the user is subscribed to it
#
class PollClosed < Event
	@name = "motion_closed"

	##
	# Creates the message to notify the user of the event
	#
	def self.handle(event)
	
		# Making a call to the API giving it a proposal number and getting a proposal 
		proposal = event["motion"]
		subscription = event["subscription"]

		percentAgree	=	MessageHelper.percentage proposal["yes_votes_count"], proposal["votes_count"]		
		percentDisagree =	MessageHelper.percentage proposal["no_votes_count"], proposal["votes_count"]
		percentAbstain	=	MessageHelper.percentage proposal["abstain_votes_count"], proposal["votes_count"]
		percentBlock	=	MessageHelper.percentage proposal["block_votes_count"], proposal["votes_count"]
	
		msg = "Proposal #{proposal["name"]} has closed. The final positions are:
Agree		=	#{percentAgree}
Disagree	=	#{percentDisagree}
Abstain		=	#{percentAbstain}
Block		=	#{percentBlock}"
		# The message
		Message.new subscription["tag"], msg
	end
end
