require_relative "user"
require 'net/http'
require 'resolv-replace'
require 'yaml'

require 'rubygems'
require 'json'
##
# Dummy API to simulate behaviors
#


class LoomioAPI

  ##
    # use loomio api to get a handle on the user, which can then be used
    # to get other data from the API

  def initialize

    # Loads from config the API URL.
    @APICommands = YAML.load_file "apiConfig.yaml"
    raise "loomio url not correctly defined!" unless @APICommands[:apiurl]
    raise "gate api url not correctly defined!" unless @APICommands[:handler_url]


    @url = @APICommands[:apiurl]
    @handlerURL = @APICommands[:handler_url]

    $stderr.puts "API initialised"
  end

  # Singleton accessor
  def self.api
    if @instance == nil
      @instance = LoomioAPI.new
    end

    return @instance
  end

  # Gets response given the api url and api parameters, and possibly params to post.
  #
  private def getResponse(apiURL, apiParams, params = nil)

    uri = URI(@url + apiURL + apiParams)
    uri.query = URI.encode_www_form(params) if params

    $stderr.puts "sending request to #{uri.to_s}"

    return Net::HTTP.get_response(uri)

  end



  # posts data in hash to the api url
  def postRequest(apiURL, data)

    uri = URI(@url + apiURL)

    $stderr.puts "sending request to #{uri.to_s} with data #{data.to_s}"

    return Net::HTTP.post_form(uri, data)


  end

  # Given a http response, returns an array with the 0th index being the HTTP status (404, 200, 403) and the rest being hash of JSON from response
  #
  private def jsonfy(res)
    if res.is_a?(Net::HTTPNotFound)
      return ['404']
    elsif res.is_a?(Net::HTTPForbidden)
      return ['403']
    elsif res.is_a?(Net::HTTPSuccess)

      parsed = JSON.parse(res.body)

      if parsed.is_a? Array
        return ['200'].concat parsed # adds the '200' in front of the array of hashes
      else
        return ['200', parsed]
      end


      return nil

    end
  end


  #
  def getUserByNumber(number)
        
        # just returns a new dummy user
        return User.new number
        
    end
    
    
    ##
    # use loomio api to get the list of groups the user is involved in
    # Returns nothing if no groups
    #
  def getUserGroups(user)
        
        # returns dummy list
        return ["Team Aqua", "Team Magma", "Team Rocket", "Team xX420BL4Z3Xx", "Test Group"]
        
    end
    
    
    
    ##
    # Gets info about the given group in the loomio database relative to that user.
    #
  def getGroupStatus(user)
    	
    	# sample output
    	return 'public'
    	
    	# return 'private'
    	
    	# return 'invalid'
    end
    
    ##
    # use loomio api to get the list of groups the user is involved in
    # Returns nothing if no groups
    #
  def getSubscribedGroups(user)
        
        # returns dummy list
        return ["Team Aqua", "Team Magma"]
        
    end
    
    ##
    # Returns an array of ongoing discussions in the group
    #


    # Gets an array of proposals in JSON format when given a subdomain name. The first member of the array is status code of whether the request was successful
  #
  #####################################################################################################################################################################################################################################################################
  def getProposalsBySubdomain(subdomain)

    return jsonfy getResponse("active_proposals/", subdomain)
  end

  #
  # Gets a single JSON representation of the latest proposal given the key of the group. returns array, whose first element is status code.
  #
  def getLatestProposalByKey(key)

    return jsonfy getResponse("proposals/", key)

  end

  #
  # Subscribe to a subdomain, given the subdomain name and the phone number which wants to receive updaterinos.
  #
  def subscribeToSubdomain(subdomain, number)

    return jsonfy postRequest("api_group_subscriptions", {:subdomain => subdomain, :tag => number, :path => @handlerURL})

  end


  #####################################################################################################################################################################################################################################################################


    ##
    # use loomio api to unsubscribe the user from the given group
    # 
    #
  def unsubscribeFromGroup(user, group)
        
        # returns result of API call or success
        return 'success'
        
    end
    
    ##
    # use loomio api to subscribe the user to the given group
    #
  def subscribeToGroup(user, group)
        
        # returns result of API call or success
        return 'success'
        
  end


    
    
    ##
    # use loomio api to get stuff the user has recently been involved in.
    #
  def getUserSummary(user)
        
        # Returns a sample summary
        return "Nothing happened in any of the groups you care about. You can charge your iPhone with a microwave now though, pretty neat."

  end


  # Gets the proposal summary by key
  def getProposalSummary(key)

    arr = getLatestProposalByKey(key)

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

      hash.each do |x|
        output << x["name"]
      end

      return output
    end

    return status

    #return ["World Domination", "Funniest Cat Picture", "An Interesting Discussion"]

  end


  ##
    # use loomio api to get stuff the user has recently been involved in.
    #
  def getPollSummary(poll)
        
        # Returns a sample summary
        return %Q(The <#{poll}> positions are
Agree		=	<50%>
Disagree	=	<80%>
Abstain		=	<10%>
Block		=	<3%>)
    end

end

#testing purposes
def test

  #puts LoomioAPI.api.subscribeToSubdomain("abstainers", "656565").to_s

  #puts LoomioAPI.api.getGroupDiscussions("abstainers").to_s

  #puts LoomioAPI.api.getProposalSummary("xEtj48Rz").to_s

  # puts LoomioAPI.api.getProposalsBySubdomain("abstainers").to_s

  #puts LoomioAPI.api.getLatestProposalByKey("xEtj48Rz").to_s

end

test