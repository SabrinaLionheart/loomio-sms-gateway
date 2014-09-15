# Require all commands
require_relative 'command'
Dir[File.dirname(__FILE__) + '/commands/*.rb'].each do |file|
	require file
end
require 'thread'

class Parser
	def initialize
		# Build a hash to relate each command name to it's class
		@commands = {}
		Command.commands.each do |command|
			@commands[command.name.upcase] = command
		end
		# A hash for partial commands
		@unfinished = {}
		# An array of numbers that are currently being processed
		@processing = []
		# Mutexes
		@mUnfinished = Mutex.new
		@mProcessing = Mutex.new
		# ConditionVariables
		@cProcessing = ConditionVariable.new
	end

	##
	# Ensures only one message for a number is being processed at once.
	# Blocks untill ready
	#
	def syncByNumber num
		@mProcessing.synchronize do
			while @processing.include? num do
				@cProcessing.wait(@mProcessing)
			end
			# Claim this number for our glorious code block
			@processing << num
		end
		# What if the block is bad?
		begin
			if block_given?
				yield
			else
				$stderr.puts "syncByNumber was not passed a codeblock why?"
			end
		# Even in an emergency the number must be freed
		ensure
			@mProcessing.synchronize do
				# Release the number
				@processing.delete num
				# Signal that a new number is free
				@cProcessing.broadcast
			end
		end
	end

	##
	# Parses and runs a command
	#
	def parse(message)
		syncByNumber message.num do
			# Be prepared for a fatal error in commands
			begin
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
			rescue Exception => e
				# The command encountered a fatal error
				# Spam information to the terminal
				puts e.message
				puts e.backtrace.inspect
				# Remove bad command
				@unfinished.delete message.num
				# Tell the user about the failure
				return Message.new message.num, "Sorry, there was a fatal error while processing your command."
			end
		end
	end
end
