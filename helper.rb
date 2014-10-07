require 'net/http'

class Helper

  def getURL(url, attempts, params)
    
    attempt = 0
    
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    
    begin 
    
    res = Net::HTTP.get_response(uri)
    
    if res.is_a?(Net::HTTPSuccess) return res

    rescue Exception => e
			$stderr.puts "Failure to sent request to #{url}, attempt #{attempt}"
			$stderr.puts e.message
			attempt += 1
			if attempt < attempts
			  retry
			else 
			  $stderr.puts "Failure to sent request to #{url}. Attempts exceeded."
			  return nil
			end
		end
    
    


end
