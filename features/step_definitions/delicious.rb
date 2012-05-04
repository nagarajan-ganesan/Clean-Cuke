class RestServicesAPI
  include HTTParty
  
  # Authorization
  def doauth(username, password)
   self.class.basic_auth username, password
  end

  # Getting the response - GET Methos  
  def get_method(requesturl)
   self.class.get(requesturl)
  end
  
  # Getting the response - POST Method
  def post_method(requesturl, headernames, headervalues, requestbody)
    
   # Set the http headers  
   header_names_array =  headernames.split(";")
   header_values_array = headervalues.split(";")
   hindex = 0
   req_header_string = ""
   total_headers = header_names_array.length
   while hindex < total_headers
     if (hindex != (total_headers - 1))
       req_header_string = req_header_string + "\"" + header_names_array[hindex] + "\"" + "=>" + "\"" + header_values_array[hindex] + "\"" + ","
     else
       req_header_string = req_header_string + "\"" + header_names_array[hindex] + "\"" + "=>" + "\"" + header_values_array[hindex] + "\""
     end
     hindex = hindex + 1
   end
   
   # Convert string to Hash
   h = {}
   req_header_string.split(',').each do |substr|
   ary = substr.strip.split('=>')
   h[ary.first.tr('"','')] = ary.last.tr('"','')
   end
   
   # calling the service with POST method
   self.class.post(requesturl, :headers => h, :body => requestbody)   
  end
  
  # PUT
  def put_method(requesturl, headernames, headervalues, requestbody)
   # Set the http headers
   header_names_array =  headernames.split(";")
   header_values_array = headervalues.split(";")
   hindex = 0
   req_header_string = ""
   total_headers = header_names_array.length
   while hindex < total_headers
     if (hindex == (total_headers - 1))
       req_header_string = req_header_string + "\"" + header_names_array[hindex] + "\"" + " => " + "\"" + header_values_array[hindex] + "\"" + ","
     else
       req_header_string = req_header_string + "\"" + header_names_array[hindex] + "\"" + " => " + "\"" + header_values_array[hindex] + "\""
     end
     hindex = hindex + 1
   end
   
   # Convert string to Hash
   h = {}
   req_header_string.split(',').each do |substr|
   ary = substr.strip.split('=>')
   h[ary.first.tr('"','')] = ary.last.tr('"','')
   end
   
   # Calling the service with PUT method
   self.class.put(requesturl, :body => "#{requestbody}")
  end    
end

And /^I make the call with "([^"]*)"$/ do |case_name|
@casename = case_name
@logtext = "Calling the service with " + case_name
end

And /^the username is "([^"]*)"$/ do |user_name|
@username = user_name
@logtext = "User name: " + user_name
end

And /^the password is "([^"]*)"$/ do |password|
@password = password
@logtext = "Password: " + password
end 

And /^executing the delicious service$/ do
# Calling the service
deliAPI = RestServicesAPI.new
deliAPI.doauth(@username, @password)
@baseurl= @baseurl + "/" + @endurl
@logtext = "Request url : " + @baseurl
request = @baseurl
puts "\nRequest URL: " + request + "\n"
uri = URI.parse(URI.encode(request.strip))
@response = deliAPI.get_method("#{uri}")
end