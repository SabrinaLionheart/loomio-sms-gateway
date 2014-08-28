# Require all commands
require_relative 'command'
Dir[File.dirname(__FILE__) + '/commands/*.rb'].each do |file|
	require file
end

class Parser
	def initialize
		# Build a hash to relate each command name to it's class
		@commands = {}
		Command.commands.each do |command|
			@commands[command.name.upcase] = command
		end
		# A hash for partial commands
		@unfinished = {}
	end
	def parse(message)
		# If a command is awaiting additional input
		if @unfinished.has_key? message.num
			command = @unfinished[message.num]
			command.ammend message
			if command.ready?
				command.run
				@commands.delete message.num
			end
		# Otherwise make a new command
		else
			command = @commands[message.msg.split.first.upcase]
			command = command.new message
			if command.ready?
				command.run
			else
				@unfinished[message.num] = command
			end
		end
	end
end
