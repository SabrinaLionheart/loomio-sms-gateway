class Command
	# The commands name
	@name = "Name not set!"
	# Stores the commands position in it's arg array
	@position = 0
	# Stores the commands args
	@args = []
	# The delimiter for args
	@delimiter = ','
	
	##
	# Creates command and parses message for arguments
	#
	def initialize(message)
		$stderr.puts "#{@name}: initialize not overridden!"
	end

	##
	# Returns true if the command is runnable
	#
	def ready?
		$stderr.puts "#{@name}: ready? not overridden!"
	end
	##
	# Parses the message for more arguments
	#
	def ammend(message)
		$stderr.puts "#{@name}: ammend not overridden!"
	end
	##
	# Performs the command
	#
	def run
		$stderr.puts "#{@name}: run not overridden!"
	end
	##
	# Gets name
	#
	def name
		return @name
	end
end
