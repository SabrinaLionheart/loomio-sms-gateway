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
		require 'sinatra/base'

		listener = Sinatra.new do
			# Tell sinatra to use port 8080
			set :port, 8080

			# Tell sinatra to do the work
			get '/' do
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
		end
		$stderr.puts "Started reciever"
		listener.run!
		# Sinatra appears to trap ctrl_c, this is a work around
		# TODO: Look into this
		exit 0
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
		require 'net/http'
		require 'yaml'
		params = nil
		begin
			params = YAML.load_file "smsConfig.yaml"
			unless params[:server] && params[:pass]
				raise "Parameters not correctly defined!"
			end
		# smsConfig.yaml is bad
		rescue
			$stderr.puts "Required parameters not present in smsConfig.yaml"
			$stderr.puts "smsConfig.yaml has been regenerated, please enter the server address and password in the configuration file."
			f = File.new "smsConfig.yaml", "w"
			params = { :server => "example.server.address.com", :pass => "Secret Password" }
			f.write params.to_yaml
			exit -1
		end
			puts "Params: #{params}"
		$stderr.puts "Started sender"
		loop do
			begin
				message = nil
				
				mutex.synchronize do
					# If there is no message wait for one
					conditionNewMessage.wait(mutex) if array.empty?
					# Get a message
					message = array.shift
				end

				# Build the url
				url = URI.parse URI.escape("http://#{params[:server]}:9090/sendsms?phone=#{message.num}&text=#{message.msg}&password=#{params[:pass]}")
				
				# Attempt to send message
				resp = Net::HTTP.get_response(url)
				
				# Report failure
				$stderr.puts "Failed to send: #{message}" unless resp.is_a?(Net::HTTPSuccess)
			# Something bad. Perhaps the phone is misbehaving again
			rescue Exception => e
				puts "Exception in smsSending"
				puts e.message
			end
		end
	end
end
