require 'yaml'

##
# Used to read and write to config files
#
class MasterConfig

	# Initialize appropriate config files
	# -------------------------------------------------------------------

	##
	# Genereate the default values for apiConfig
	def self.defaultAPI
		serverHash = {}
		serverHash['server'] = "http://rd.severinmm.com:3000/api/v1"
		serverHash['handler_url'] = "http://Home.SeverinMM.com:8080/api/event"
		serverHash['api_path'] = "/api/v1"
		
		File.open("config/apiConfig.yaml", 'w') do |a|
			a.write serverHash.to_yaml
		end
	end

	##
	# Generate the default values for smsConfig
	def self.defaultSMS
		smsHash = {}
		smsHash['server'] = "Home.SeverinMM.com"
		smsHash['pass'] = "sauce"

		File.open("config/smsConfig.yaml", 'w') do |b|
			b.write smsHash.to_yaml
		end
	end
	
	# Check that apiConfig.yaml exists
	unless File.file?('config/apiConfig.yaml')
		defaultAPI
	end
	# Check that smsConfig.yaml exists
	unless File.file?('config/smsConfig.yaml')
		defaultSMS
	end
	
	# API config functions
	# --------------------------------------------------------------------

	##
	# Get the URL for the server that the api must interface to
	#
	def self.getAPIServer
		value = fromFile "api", "server"

		$stderr.puts "no value was found for api server" unless value

		return value
	end

	##
	# Get the URL for the api handler
	#
	def self.getAPIHandler
		value = fromFile "api", "handler_url"

		$stderr.puts "no value was found for api server" unless value

		return value
	end

	##
	# Get the path for the API
	#
	def self.getAPIPath
		value = fromFile "api", "api_path"

		$stderr.puts "no value was found for api server" unless value

		return value
	end

	
	##
	# Edit the apiConfig.yaml file 
	#
	def self.newAPIConfig serverURL, handlerURL, apiPath
		serverHash = {}
		serverHash['server'] = serverURL
		serverHash['handler_url'] = handlerURL
		serverHash['api_path'] = apiPath
		
		File.open("config/apiConfig.yaml", 'w') do |a|
			a.write serverHash.to_yaml
		end

		return serverHash
	end


	# SMS config functions
	# ----------------------------------------------------------------------

	##
	# Get the server url for the sms server
	#
	def self.getSMSServer
		value = fromFile "sms", "server"
		
		$stderr.puts "no value was found for sms server" unless value

		return value
	end

	##
	# Get the server pw for the sms server
	#
	def self.getSMSPass
		value = fromFile "sms", "pass"

		$stderr.puts "no value was found for sms password" unless value

		return fromFile "sms", "pass"
	end
	##
	# Edit the smsConfig.yaml file
	#
	def self.newSMSConfig server, password
		smsHash = {}
		smsHash['server'] = server
		smsHash['pass'] = password

		File.open("config/smsConfig.yaml", 'w') do |b|
			b.write smsHash.to_yaml
		end

		return smsHash
	end

	# ----------------------------------------------------------------------

	##
	# Retrieve a value from file using given input
	#
	def self.fromFile filename, key
		config = nil
		if filename.eql? "api"
			config = "config/apiConfig.yaml"
			unless File.file? config
				$stderr.puts "API config file was not found. Creating new file using defaults"
				defaultAPI
			end
		
		elsif filename.eql? "sms"
			config = "config/smsConfig.yaml" 
			unless File.file? config
				$stderr.puts "SMS config file was not found. Creating new file using defaults"
				defaultSMS
			end

		else
			config = nil
		end

		conFile = YAML::load_file(File.join(__dir__, config))
		value =  conFile[key]
		
		return nil unless value
		return value
	end


	# Private methods
	private_class_method :fromFile, :defaultSMS, :defaultAPI

end
