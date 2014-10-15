require 'net/http'
require 'yaml'

require 'rubygems'
require 'json'

##
# Accesses the API on Loomio's end
#
class LoomioAPI
  # Loads from config the API URL.
  @APICommands = YAML.load_file "apiConfig.yaml"
  raise "loomio url not correctly defined!" unless @APICommands[:apiPath]
  raise "Server URL not correctly defined!" unless @APICommands[:apiurl]
  raise "gate api url not correctly defined!" unless @APICommands[:handler_url]


  @uri = URI.parse(@APICommands[:apiurl])
  @http = Net::HTTP.new @uri.host, @uri.port
  @path = @APICommands[:apiPath]
  @handlerURL = @APICommands[:handler_url]
  $stderr.puts "API initialised"

  class << self
    # REST GET query, given the api url and api parameters, and possibly URL parameters.
    #
    def getResponse(apiURL, apiParams, params = nil)

      req = Net::HTTP::Get.new(@path + apiURL + '/' + apiParams)
      req.set_form_data(params) unless params == nil

      $stderr.puts "sending GET to #{@uri.to_s + @path + apiURL}"

      return @http.request(req)

    end


    # REST POST query, posting the data to the URI with API parameters and data
    def postRequest(apiURL, apiParams = "", data)

      req = Net::HTTP::Post.new(@path + apiURL + '/' + apiParams)
      req.set_form_data(data)

      $stderr.puts "sending POST to #{@uri.to_s + @path + apiURL} with data #{data.to_s}"

      return @http.request(req)


    end

    # REST DELETE query, given the API path and the uri of the thing to delete and data.
    #
    def deleteRequest(apiURL, apiParams, data = nil)
      req = Net::HTTP::Delete.new(@path + apiURL + '/' + apiParams)
      req.set_form_data(data) unless data == nil

      $stderr.puts "sending DELETE to #{@uri.to_s + @path + apiURL} with data #{data.to_s}"

      return @http.request(req)
    end

    # Given a http response, returns an array with the 0th index being the HTTP 
    # status (404, 200, 403) and the rest being hash of JSON from response
    #
    def jsonfy(res)
      if res.is_a?(Net::HTTPNotFound)
        return [404]
      elsif res.is_a?(Net::HTTPForbidden)
        return [403]
      elsif res.is_a?(Net::HTTPSuccess)
        parsed = JSON.parse(res.body)
        return [200, parsed]
      end
      return nil
    end

    # Gets an array of proposals in JSON format when given a subdomain name. 
    # The first member of the array is status code of whether the request was successful
    #
    def getProposalsBySubdomain(subdomain)
      return jsonfy getResponse("/active_proposals", subdomain)
    end

    # Gets a single JSON representation of a proposal given its key.
    # returns array, whose first element is status code, and second element is a hash representation of the proposal
    #
    def getProposalByKey(key)
      return jsonfy getResponse("/proposals", key)
    end

    # Subscribe to a subdomain, given the subdomain name and the phone number which wants
    # to receive updaterinos. Returns array with status code as 1st element, and hash of unsubscription info as second
    #
    def subscribeToSubdomain(subdomain, number)
      return jsonfy postRequest("/api_group_subscriptions", {:subdomain => subdomain,
                                                            :tag => number, :path => @handlerURL})
    end

    # Unsubscribe from a subdomain, given the subdomain name and the number who wants to unsub
    #
    #
    def unsubscribeFromSubdomain(subdomain, number)
      return jsonfy deleteRequest("/api_group_subscriptions", subdomain, {:tag => number, :path => @handlerURL})
    end


    private :getResponse, :postRequest, :deleteRequest, :jsonfy
  end
end

`
#testing purposes
def test
  puts LoomioAPI.subscribeToSubdomain("abstainers", "656565").to_s

  puts LoomioAPI.getProposalsBySubdomain("abstainers").to_s

  puts LoomioAPI.getProposalByKey("xEtj48Rz").to_s

  puts LoomioAPI.unsubscribeFromSubdomain("abstainers", "656565").to_s
end

test
`
