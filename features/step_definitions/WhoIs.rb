require 'rubygems'
require 'httparty'
require 'json'
require 'pp'
require 'rexml/document'
require 'hpricot'
require 'uri'
require 'logger'

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

#Constructing Email body
@htmlEMailCnt = $htmlEMailContent + "<br><b><font color = \"blue\">Feature Name: Testing whoismyrepresentative API" + "</font><br><br>"
@htmlEMailCnt = @htmlEMailCnt + "<Table border=\"1\">"
@htmlEMailCnt = @htmlEMailCnt + "<tr bgcolor=\"aqua\">"
@htmlEMailCnt = @htmlEMailCnt + "<th>S.No</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Snenarion Name</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Request URL</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Method</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Response</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Tags verified</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Tags missing</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Format</th>"
@htmlEMailCnt = @htmlEMailCnt + "<th>Result</th></tr>"
$htmlEMailContent = @htmlEMailCnt


# Reading base URL for this feature
$baseURL = $config_xml.cucumberconfig.features.feature(:css => "[name='NagWS']").baseurl.content
Before do
@htmlEMailCnt = $htmlEMailContent
@baseurl = $baseURL
end

# Step hook - will be executed after each cucumber step to log the execution
AfterStep do
 if (@logtext.length > 0)
  $msgLog.logtext @logtext
 end
end

# Scenarion hook - will be executed after end of each scenario
After do |scenario|
  @htmlEMailCnt = @htmlEMailCnt + @scenarioresult
  $htmlEMailContent = @htmlEMailCnt
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
@baseurl= @baseurl + "/" + @endurl + "?" + @paramname  + "=" + value
@logtext = "Request url : " + @baseurl
puts "\nRequest URL: " + @baseurl
puts "\n"
@value = value
end

And /^request for "([^"]*)"$/ do |format|
@format = format
request = @baseurl
  uri = URI.parse(URI.encode(request.strip))
  if format == 'xml'
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
       @tagsverified = @tagsverified + tag + ","
     else
       puts "Tag not found: " + tag
       @logtext = @logtext + "Did not found the tag: " + tag + ","
       @tagsmissing = @tagsmissing + tag + ","
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
$sno = $sno + 1
@scenarioresult = ""
if (@result == "Pass")
   respart = "<td><font color=\"green\">PASS</font></td>"
else
   respart = "<td><font color=\"red\">FAIL</font></td>"
end
@scenarioresult = "<tr><td>" + $sno.to_s() + "</td><td>Testing of " + @endurl + "</td><td>" + @baseurl + "</td><td>" + @method + "</td><td>" + @response.code.to_s() + "-" + @response.message + "</td><td>" + @tagsverified + "</td><td>" + @tagsmissing + "</td><td>" + @format + "</td>" + respart + "</tr>"
end