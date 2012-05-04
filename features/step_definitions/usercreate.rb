And /^the request body is "([^"]*)"$/ do |reqbodyfile|
@reqbodyfile = reqbodyfile
f = File.open("features/data_files/" + @reqbodyfile)
@bodycontent = f.read
@bodycontent = @bodycontent.gsub("<username>", @username)
@bodycontent = @bodycontent.gsub("<password>", @password)
@logtext = "Calling the service with request body " + @reqbodyfile
end

And /^executing the user create service$/ do
# Calling the service
userAPI = RestServicesAPI.new
@baseurl= @baseurl + "/" + @endurl
@logtext = "Request url : " + @baseurl
request = @baseurl
puts "\nRequest URL: " + request + "\n"
uri = URI.parse(URI.encode(request.strip))
@response = userAPI.post_method("#{uri}", @headerNames, @headerValues, @bodycontent)
end