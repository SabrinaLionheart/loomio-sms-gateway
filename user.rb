##
# User handle which is a reference to the loomio user
#
class User
    
    @number = 42 # Not Exzaiden's number
    
    # dummy command to create a user with given number
    def initialize(num)
        @number = num
    end
    
    def number
        return @number
    end
    
end
