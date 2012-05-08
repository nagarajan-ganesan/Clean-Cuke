class Representative_XML
  include HTTParty
  format :xml  
  def self.get_response(baseurl, paramname, paramvalue)
     get(baseurl)
  end
end

class Representative_JSON
  include HTTParty
  default_params :output => 'json'
  format :json
  def self.get_response(baseurl, paramname, paramvalue)
     get(baseurl)
  end
end

Given /^The service base url is from config file$/ do
  @logtext = ""
end

And /^the service end url is "([^"]*)"$/ do |end_url|
  @endurl = end_url    
  @logtext = ""
end

When /^I make a "([^"]*)" request$/ do |method|
@method = method
@logtext = "Requesting with " + @method + " method"
end

And /^send the service parameter "([^"]*)"$/ do |paramname|
@paramname = paramname
@logtext = ""
end

And /^the parameter value is "([^"]*)"$/ do |value|
@baseurl= "#{@baseurl}/#{@endurl}?#{@paramname}=#{value}"

@logtext = "Request url : " + @baseurl
puts "\nRequest URL: " + @baseurl
puts "\n"
@value = value
end

And /^request for "([^"]*)"$/ do |format|
@format = format
puts "FORMAT: " + @format
request = @baseurl
  uri = URI.parse(URI.encode(request.strip))
  if (@format == 'xml')
    @response = Representative_XML.get_response("#{uri}", @paramname, @value)    
  else
    @response = Representative_JSON.get_response("#{uri}", @paramname, @value)
  end
  @logtext = "Format = " + format
end

Then /^the response code should be "([^"]*)"$/ do |rescode|
@result = "Pass"  
if (rescode == @response.code.to_s()) 
  puts "Response code is as expected" + "\n"
else
  puts "Response code is not as expected" + "\n"
  @result = "Fail"
end
@logtext = "Response code = " + @response.code.to_s()
end

And /^I should see the tags "([^"]*)" in the response$/ do |tags|
  puts "Response Code: " + @response.code.to_s() + "\n"
  puts "Response Message: " + @response.message  + "\n"
  #puts "Response Body:" + "\n"  
  #puts @response.body + "\n"
  
  @logtext = ""
  @tagsverified = ""
  @tagsmissing=""
  @temp = @response.body
  tag_array = tags.split(", ")
  tag_array.each do |tag|
     tagindex = 0
     tagindex = @temp.index(tag)
     if (tagindex != nil)
       puts "Found the tag: " + tag
       @logtext = @logtext + "Found the tag: " + tag + ","
       @tagsverified = @tagsverified + tag + ", "
     else
       puts "Tag not found: " + tag
       @logtext = @logtext + "Did not found the tag: " + tag + ","
       @tagsmissing = @tagsmissing + tag + ", "
       @result = "Fail"
     end
     puts "\n"
  end  
end

And /^the response should be in "([^"]*)"$/ do |format|
  if (format == 'xml' && @response.headers['content-type'].index(format) > 0)
    puts "Response format is as expected : " + format + "\n"
    @logtext = "Response format is as expected : " + format
  end
  
  if (format == 'json' && @response.headers['content-type'].index("xml") == nil)
    puts "Response format is as expected : " + format + "\n"
    @logtext = "Response format is as expected : " + format
  end
end