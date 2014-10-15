require_relative 'loomioAPI'
require_relative 'MessageHelper'
##
# The super class for commands
# Creates an array of children to track commands
#
class Command
	# Make @name and @delimiter acessable class variables
	class << self
		attr_accessor :commands
	end
	# The array of commands
	@commands = []
	
	##
	# Creates an array of all commands and sets class variables for children
	#
	def self.inherited(command)
		# Makes child commands inherit @name and @delimiter
		# DEBUG:
		$stderr.puts "Added command #{command}."
		# Append command to array of commands
		@commands << command
	end

	##
	# Processes the message and if possible performs the command
	# Returns a message as a responce or nil
	#
	def self.process(message)
		$stderr.puts "#{self} did not override process!"
		nil
	end
end
