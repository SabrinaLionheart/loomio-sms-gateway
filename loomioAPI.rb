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
    raise "loomio url not correctly defined!" unless @APICommands[:apiPath]
    raise "Server URL not correctly defined!" unless @APICommands[:apiurl]
    raise "gate api url not correctly defined!" unless @APICommands[:handler_url]


    @uri = URI.parse(@APICommands[:apiurl])
    @http = Net::HTTP.new @uri.host, @uri.port
    @path = @APICommands[:apiPath]
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

            req = Net::HTTP::Get.new(@path + apiURL + '/' + apiParams)
            req.set_form_data(params) unless params == nil

            $stderr.puts "sending GET to #{@uri.to_s + @path + apiURL}"

            return @http.request(req)

          end



  # posts data in hash to the api url
  def postRequest(apiURL, apiParams = "", data)

    req = Net::HTTP::Post.new(@path + apiURL + '/' + apiParams)
    req.set_form_data(data)

    $stderr.puts "sending POST to #{@uri.to_s + @path + apiURL} with data #{data.to_s}"

    return @http.request(req)


  end

  def deleteRequest(apiURL, apiParams, data)

    req = Net::HTTP::Delete.new(@path + apiURL + '/' + apiParams)
    req.set_form_data(data)

    $stderr.puts "sending DELETE to #{@uri.to_s + @path + apiURL} with data #{data.to_s}"

    return @http.request(req)


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


  # Gets an array of proposals in JSON format when given a subdomain name. The first member of the array is status code of whether the request was successful
  #
  #####################################################################################################################################################################################################################################################################
  def getProposalsBySubdomain(subdomain)

    return jsonfy getResponse("/active_proposals", subdomain)
  end

  #
  # Gets a single JSON representation of the latest proposal given the key of the group. returns array, whose first element is status code.
  #
  def getLatestProposalByKey(key)

    return jsonfy getResponse("/proposals", key)

  end

  #
  # Subscribe to a subdomain, given the subdomain name and the phone number which wants to receive updaterinos.
  #
  def subscribeToSubdomain(subdomain, number)

    return jsonfy postRequest("/api_group_subscriptions", {:subdomain => subdomain, :tag => number, :path => @handlerURL})

  end


  def unsubscribeFromSubdomain(subdomain, number)

    return jsonfy deleteRequest("/api_group_subscriptions/", subdomain, {:tag => number, :path => @handlerURL})

  end

  #####################################################################################################################################################################################################################################################################


end

#testing purposes
def test

  begin

    #puts LoomioAPI.api.subscribeToSubdomain("abstainers", "656565").to_s

    #puts LoomioAPI.api.getProposalsBySubdomain("abstainers").to_s

    #puts LoomioAPI.api.getLatestProposalByKey("xEtj48Rz").to_s

    #puts LoomioAPI.api.unsubscribeFromSubdomain("abstainers", "656565").to_s

  rescue Exception

    $stderr.puts "TESTING FAIELD"

  end




end

test