##
# A poll is closing and the user is subscribed to it
#
class PollClosing < Event
	@name = "motion_closing_soon"

	##
	# Creates the message to notify the user of the event
	#
	def self.handle(event)
		proposal = event["motion"]
		subscription = event["subscription"]
		hoursRemaining = event["hours_remaining"]

		percentAgree	=	MessageHelper.percentage proposal["yes_votes_count"], proposal["votes_count"]		
		percentDisagree =	MessageHelper.percentage proposal["no_votes_count"], proposal["votes_count"]
		percentAbstain	=	MessageHelper.percentage proposal["abstain_votes_count"], proposal["votes_count"]
		percentBlock	=	MessageHelper.percentage proposal["block_votes_count"], proposal["votes_count"]
		totalVotes		=	proposal["votes_count"]
		
		msg = "The proposal #{proposal["name"]} is closing in #{hoursRemaining} hours. The current positions are:
Agree		=	#{percentAgree}%
Disagree	=	#{percentDisagree}%
Abstain		=	#{percentAbstain}%
Block		=	#{percentBlock}%
Total number of votes = #{totalVotes}"
		# The message
		Message.new subscription["tag"], msg
	end
end
