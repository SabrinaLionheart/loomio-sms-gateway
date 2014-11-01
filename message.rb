##
# Represents an sms message
#
class Message
	##
	# Creates a new message
	#
	# ==== Attributes
	# * +num+ - The source or destination of the message
	# * +msg+ - The contents of the message
	def initialize(num, msg)
		@num = num
		@msg = msg
	end
	# The source or destination of the message
	attr_accessor :num
	# The contents of the message
	attr_accessor :msg
end
