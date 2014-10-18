class SMSManager
	##
	# Gets all messages and stores them in the provided array in a synchronized way
	#
	# This get's it's own thread to run in, sinatra doesn't require it but other implementations
	# might.
	# 
	# Array is the array messages are stored in
	# Mutex is the mutex guarding access to the array
	# ConditionNewMessage is to be signalled whenever a message is added
	# 
	def self.getSMS(array, mutex, conditionNewMessage)
		require_relative 'gateAPI'
		GateAPI.get '/sms/?' do
			# Make sure the required parameters are present
			# Report when they are missing
			return "Need parameter phone" unless params[:phone]
			return "Need parameter text" unless params[:text]
			
			# Add the message to the array
			mutex.synchronize do
				array << Message.new(params[:phone], params[:text])
				conditionNewMessage.signal
			end
			return "Message recieved."
		end
		$stderr.puts "Started receiver"
	end
	##
	# Sends all messages in the array in a synchronized way
	# 
	# This function will get it's own thread to run in
	#
	# Array is the array of messages to send
	# Mutex guards access to the array
	# ConditionNewMessage will notify this function that there are new messages to send
	#
	def self.sendSMS(array, mutex, conditionNewMessage)
		require_relative 'masterConfig'
		require 'net/http'
		require 'resolv-replace'
		$stderr.puts "Started sender"
		loop do
			message = nil
			attempts = 0	
			mutex.synchronize do
				# If there is no message wait for one
				conditionNewMessage.wait(mutex) if array.empty?
				# Get a message
				message = array.shift
			end

			begin
				# Build the url
				url = URI.parse URI.escape("http://#{MasterConfig.getSMSServer}:9090/sendsms?phone=#{message.num}&text=#{message.msg}&password=#{MasterConfig.getSMSPass}")
				
				# Attempt to send message
				resp = Net::HTTP.get_response(url)
				
				# Report failure
				$stderr.puts "Failed to send: #{message}" unless resp.is_a?(Net::HTTPSuccess)
			# Something bad. Perhaps the phone is misbehaving again
			rescue Exception => e
				$stderr.puts "Exception in smsSending"
				$stderr.puts e.message
				attempts += 1
				retry if attempts < 3
			end
		end
	end
end
