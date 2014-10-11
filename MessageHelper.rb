class MessageHelper
	def self.percentage(numerator, denominator)
		return 0 if denominator == 0
		x = (numerator.to_f/denominator)*100
		return x.round
	end 
end