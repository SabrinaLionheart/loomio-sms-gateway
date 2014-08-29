class Command
	# Make @name and @delimiter acessable class variables
	class << self
		attr_accessor :name, :delimiter, :commands
	end
	# The commands name
	@name = "Name not set!"
	# The delimiter for args
	@delimiter = ','
	# The array of commands
	@commands = []
	
	##
	# Creates command and parses message for arguments
	#
	def initialize(message)
		$stderr.puts "#{@name}: initialize not overridden!"
	end

	##
	# Creates an array of all commands
	def self.inherited(command)
		# Makes child commands inherit @name and @delimiter
		command.instance_variable_set(:@name, @name)
		command.instance_variable_set(:@delimiter, @delimiter)
		# DEBUG:
		puts "Added command #{command}."
		@commands << command
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
	# Returns a message to be sent
	#
	def response
		@response
	end
	##
	# Gets name
	#
	def name
		self.class.name
	end
end
