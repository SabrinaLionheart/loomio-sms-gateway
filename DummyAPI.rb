##
# Dummy API to simulate behaviors
#
class DummyAPI
    
    
    
    ##
    # use loomio api to get a handle on the user, which can then be used to get other data from the API
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
        return ["group", "another group"]
        
    end
    
    ##
    # use loomio api to get the list of groups the user is involved in
    # Returns nothing if no groups
    #
    def self.getSuscribedGroups(user)
        
        # returns dummy list
        return ["group"]
        
    end
    
    
    ##
    # use loomio api to unsuscribe the user from the given group
    # 
    #
    def self.unsuscribeFromGroup(user, group)
        
        # returns success?
        return true
        
    end
    
    ##
    # use loomio api to suscribe the user to the given group
    # 
    #
    def self.suscribeToGroup(user, group)
        
        # returns success?
        return true
        
    end
    
    
    
    ##
    # use loomio api to get stuff the user has recently been involved in.
    #
    def self.getUserSummary(user)
        
        # Returns a sample summary
        return "Today sum stuff happended for user with number #{user.number} on lumio, enjoy your'e day"
        
    end
    
end


