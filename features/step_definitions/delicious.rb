class DeliciousAPI
  include HTTParty
  
  # Authorization
  def initialize(username, password)
   self.class.basic_auth username, password
  end

  # Getting the response  
  def get_response(requesturl)
   self.class.get(requesturl)
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

# Calling the service
deliAPI = DeliciousAPI.new(@username, @password)
@baseurl= @baseurl + "/" + @endurl
@logtext = "Request url : " + @baseurl
request = @baseurl
puts "\nRequest URL: " + request + "\n"
uri = URI.parse(URI.encode(request.strip))
@response = deliAPI.get_response("#{uri}")
end