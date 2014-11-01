require 'sqlite3'
##
# A hacked together singleton for a sqlite3 database
# This should be replaced with a better database
#
class Database
	# Open database
	@database = SQLite3::Database.new "gate.db"

	# Ensure keymap table exists
	@database.execute <<-SQL 
		CREATE TABLE IF NOT EXISTS keymap
			(
				number VARCHAR(16),
				proposal VARCHAR(8),
				friendly_number INT
			);"
	SQL
	
	class << self
		##
		# Takes a key and returns a nicer number
		#
		# ==== Attributes
		#
		# * +num+ - The number of the user
		# * +key+ - The key you wish to map to a nicer number
		#
		def makeFriendly(num, key)
			result = @database.execute "SELECT * FROM keymap WHERE number=? AND proposal=?;", [num, key]
			return result.first.last unless result.empty?
			result = @database.execute "SELECT * FROM keymap WHERE number=? ORDER BY friendly_number DESC;", num
			if result.empty?
				nextFriendly = 1
			else
				nextFriendly = result.first.last + 1
			end
			puts "New friendlyNumber for #{num} (#{nextFriendly})"
			@database.execute "INSERT INTO keymap VALUES (?,?,?);", [num,key,nextFriendly]
			return nextFriendly
		end

		##
		# Takes a friendly number and returns the key
		#
		# ==== Attributes
		#
		# * +num+ - The number of the user
		# * +friendly_number+ - The friendly number representing the key you want
		#
		def getKey(num, friendly_number)
			result = @database.execute "SELECT * FROM keymap WHERE number=? AND friendly_number=?;", [num,friendly_number]
			return result.first[1] unless result.empty?
			return nil
		end
	end
end

'
puts "I am OK"
puts Database.makeFriendly "123", "palsssss"
puts Database.makeFriendly "123", "chumssss"
puts Database.makeFriendly "123", "budskiis"

puts Database.getKey "123", 1
puts Database.getKey "123", 2
puts Database.getKey "123", 3

puts Database.makeFriendly "321", "budskiis"
puts Database.makeFriendly "321", "chumssss"
puts Database.makeFriendly "321", "palsssss"

puts Database.getKey "321", 1
puts Database.getKey "321", 2
puts Database.getKey "321", 3
'
