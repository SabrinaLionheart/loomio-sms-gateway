# Require all commands
require_relative 'command'
Dir[File.dirname(__FILE__) + '/commands/*.rb'].each do |file|
	require file
end
require 'thread'

class Parser
	def initialize(maxAge)
		# Build a hash to relate each command name to it's class
		@commands = {}
		Command.commands.each do |command|
			@commands[command.name.upcase] = command
		end
		# An array of hashs for partialy complete commands
		@unfinished = []
		maxAge.times do
			@unfinished << {}
		end
		# An array of numbers that are currently being processed
		@processing = []
		# Mutexes
		@mUnfinished = Mutex.new
		@mProcessing = Mutex.new
		# ConditionVariables
		@cProcessing = ConditionVariable.new
		# Create ReaperThread to cull the old commands
		@reaperThread = Thread.new do
			loop do
				sleep 60
				ageCommands
			end
		end
	end

	##
	# Get a command from the array of hashes
	# Remove it from the hashes
	#
	def takeCommand(num)
		@mUnfinished.synchronize do
			@unfinished.each do |hash|
				command = hash[num]
				if command
					hash.delete num
					return command
				else
					next
				end
			end
		end
		return nil
	end

	##
	# Add a command to the youngest hash in the array of hashes
	#
	def addCommand(num, command)
		@mUnfinished.synchronize do
			@unfinished.first[num] = command
		end
	end

	##
	# Ages the unfinished commands by one unit
	# Removes expired commands
	#
	def ageCommands
		@mUnfinished.synchronize do
			@unfinished.unshift Hash.new
			@unfinished.pop
		end
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
				command = takeCommand message.num
				if command
					# Ammend the command
					command.ammend message
				# Otherwise make a new command
				else
					# This gets the class of the command
					# TODO: Investigate parsing of command name make it better
					command = @commands[message.msg.split.first.upcase]
					# Check the command exists
					unless command
						puts "Bad command"
						puts message.inspect
						# Error message would go here
						return Message.new message.num, "Your command was invalid. NewPoll is the only command at the moment."
					end
					# Actually make the command
					command = command.new message
				end
				if command.ready?
					command.run
				else
					addCommand message.num, command
				end
				return command.response
			rescue Exception => e
				# The command encountered a fatal error
				# Spam information to the terminal
				puts e.message
				puts e.backtrace.inspect
				# Tell the user about the failure
				return Message.new message.num, "Sorry, there was a fatal error while processing your command."
			end
		end
	end
end
