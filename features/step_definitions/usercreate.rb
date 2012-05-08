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

And /^the response should match the output schema "([^"]*)"$/ do |output_schema_file|
# Response - Validate with schema if response code is 200
 if (@response.code == 200)
   parsed_response_body = JSON.parse(@response.body)
   parsed_output_schema = JSON.parse(File.read("features/data_files/" + output_schema_file))
   begin
    JSON::Validator.validate!(parsed_output_schema, parsed_response_body)
    @logtext = "Schema matchces as per the output schema file #{output_schema_file}"
    @result = "Pass"
    puts "Schema matches as expected"
   rescue JSON::Schema::ValidationError
    @logtext = "Schema does not as per the output schema file #{output_schema_file} : " + $!.message
    @result = "Fail"  
    puts "Schema does not match as expected"
   end
 end
end