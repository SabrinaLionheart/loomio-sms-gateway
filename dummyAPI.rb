require_relative "user"

##
# Dummy API to simulate behaviors
#
class DummyAPI
    
    ##
    # use loomio api to get a handle on the user, which can then be used
	# to get other data from the API
    #
    def self.getUserByNumber(number)
        
        # just returns a new dummy user
        return User.new number
        
    end
    
    
    ##
    # use loomio api to get the list of groups the user is involved in
    # Returns nothing if no groups
    #
    def self.getUserGroups(user)
        
        # returns dummy list
        return ["Team Aqua", "Team Magma", "Team Rocket"]
        
    end
    
    ##
    # use loomio api to get the list of groups the user is involved in
    # Returns nothing if no groups
    #
    def self.getSubscribedGroups(user)
        
        # returns dummy list
        return ["Team Aqua"]
        
    end
    
    ##
    # use loomio api to unsubscribe the user from the given group
    # 
    #
    def self.unsubscribeFromGroup(user, group)
        
        # returns success?
        return true
        
    end
    
    ##
    # use loomio api to subscribe the user to the given group
    #
    def self.subscribeToGroup(user, group)
        
        # returns success?
        return true
        
    end
    
    
    
    ##
    # use loomio api to get stuff the user has recently been involved in.
    #
    def self.getUserSummary(user)
        
        # Returns a sample summary
        return "Nothing happened in any of the groups you care about. You can charge your iPhone with a microwave now though, pretty neat."
        
    end
    
end


