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
    # Gets response given the api url and api parameters, and possibly params to post.
    #
    def getResponse(apiURL, apiParams, params = nil)
      uri = URI(@uri + apiURL + apiParams)
      uri.query = URI.encode_www_form(params) if params
  
      $stderr.puts "sending request to #{uri.to_s}"
  
      return Net::HTTP.get_response(uri)
    end
  
    # posts data in hash to the api url
    def postRequest(apiURL, data)
      uri = URI(@uri + apiURL)
  
      $stderr.puts "sending request to #{uri.to_s} with data #{data.to_s}"
  
      return Net::HTTP.post_form(uri, data)
    end
   
    def deleteRequest(apiURL, apiParams, data)
      req = Net::HTTP::Delete.new(@path + apiURL + '/' + apiParams)
      req.set_form_data(data)

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
      return jsonfy getResponse("active_proposals/", subdomain)
    end
  
    # Gets a single JSON representation of a proposal given it's key/
    # returns array, whose first element is status code.
    #
    def getProposalByKey(key)
      return jsonfy getResponse("proposals/", key)
    end
  
    # Subscribe to a subdomain, given the subdomain name and the phone number which wants
    # to receive updaterinos.
    #
    def subscribeToSubdomain(subdomain, number)
      return jsonfy postRequest("api_group_subscriptions", {:subdomain => subdomain, 
  	                          :tag => number, :path => @handlerURL})
    end
  
    def unsubscribeFromSubdomain(subdomain, number)
      return jsonfy deleteRequest("/api_group_subscriptions", subdomain, {:tag => number, :path => @handlerURL})
    end

    # Gets the proposal summary by key
    def getProposalSummary(key)
      arr = getProposalByKey(key)
      if arr[0] == "200" # if key exists
        hash = arr[1]
  
        # returns array in the order of yes,no,abstain,block
        return [hash["yes_votes_count"], hash["no_votes_count"], hash["abstain_votes_count"], hash["block_votes_count"]]
      end
      return arr[0]
    end
  
    # Gets the latest proposals of the given subdomain
    def getGroupDiscussions(group)
      hash = getProposalsBySubdomain(group)
  
      if (status = hash.shift) == "200"
        output = Array.new
        hash = hash.first
        hash.each do |x|
          output << x["name"]
        end
        return output
      end
  
      return status
    end
  
    private :getResponse, :postRequest, :jsonfy
  end
end

'
#testing purposes
def test
  puts LoomioAPI.subscribeToSubdomain("abstainers", "656565").to_s

  puts LoomioAPI.getGroupDiscussions("abstainers").to_s

  puts LoomioAPI.getProposalSummary("xEtj48Rz").to_s

  puts LoomioAPI.getProposalsBySubdomain("abstainers").to_s

  puts LoomioAPI.getProposalByKey("xEtj48Rz").to_s

  puts LoomioAPI.unsubscribeFromSubdomain("abstainers", "656565").to_s
end

test
'
