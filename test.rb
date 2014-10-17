require_relative 'masterConfig'

puts "-testing-"

puts MasterConfig.getAPIServer
puts MasterConfig.getAPIHandler
puts MasterConfig.getAPIPath

puts MasterConfig.getSMSServer
puts MasterConfig.getSMSPass

#puts fromFile "sms", "pass"
#puts defaultAPI
#puts defaultSMS

#puts MasterConfig.newAPIConfig "hello", "world", "!"
#puts MasterConfig.newSMSConfig "weird", "ness"