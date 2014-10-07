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
			@commands[command.to_s.upcase] = command
		end
	end

	##
	# Parses and runs a command
	#
	def parse(message)
		# Be prepared for a fatal error in commands
		begin
			# This gets the class of the command
			# TODO: Investigate parsing of command name make it better
			command = @commands[message.msg.split(" ", 2).first.upcase]
			# Check the command exists
			unless command
				$stderr.puts "Bad command"
				$stderr.puts message.inspect
				# Error message would go here
				return Message.new message.num, "Your command was invalid. Here are the avaliable commands: #{Command.commands.join ", "}"
			end
			# Actually make the command
			return command.process message
		rescue Exception => e
			# The command encountered a fatal error
			# Spam information to the terminal
			$stderr.puts e.message
			$stderr.puts e.backtrace.inspect
			# Tell the user about the failure
			return Message.new message.num, "Sorry, there was a fatal error while processing your command."
		end
	end
end
