##
# Helps messages with additional functions
#
class MessageHelper
	##
	# Calculates percentages
	#
	# ==== Attributes
	#
	# * +numerator+ - The numerator of the fraction you wish to convert to a percentage
	# * +denominator+ - The denominator of the fraction you wish to convert to a percentage
	#
	def self.percentage(numerator, denominator)
		return 0 if denominator == 0
		x = (numerator.to_f/denominator)*100
		return x.round
	end 
end
