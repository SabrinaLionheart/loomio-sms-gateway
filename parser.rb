# Require all commands
require 'command'
Dir[File.dirname(_FILE_) + '/commands/*.rb'].each do |file|
	require file
end

class Parser
	def initialise
		# Build a hash to relate each command name to it's class
		commands = {}
		Command.commands.each do |command|
			commands[command.name.upcase] = command
		end
		# A hash for partial commands
		unfinished = {}
	end
end
