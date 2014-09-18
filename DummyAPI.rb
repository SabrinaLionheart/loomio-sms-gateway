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
    def self.getUserGroup(user)
        
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
    # use loomio api to get stuff the user has recently been involved in.
    #
    def self.getUserSummary(user)
        
        return "Today sum stuff happended for user with number #{user.number} on lumio, enjoy your'e day"
        
    end
    
end


##
# User handle which is a reference to the loomio user
#
class User
    
    @number = 23451235
    
    # dummy command to create a user with given number
    def self.new(num)
        @number = num
    end
    
    def number
        return @number
    end
    
end
