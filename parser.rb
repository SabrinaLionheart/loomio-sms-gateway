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
			# Get command
			command = @unfinished[message.num]
			command.ammend message
			if command.ready?
				command.run
				# The command was used remove it
				@unfinished.delete message.num
			end
			# Perhaps the command wanted to say something
			return command.response	
		# Otherwise make a new command
		else
			command = @commands[message.msg.split.first.upcase]
			# Check the command exists
			unless command
				puts "Bad command"
				puts message.inspect
				# Error message would go here
				return nil
			end
			command = command.new message
			if command.ready?
				command.run
			else
				@unfinished[message.num] = command
			end
			return command.response
		end
	end
end
