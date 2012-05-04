# Tagged Scenario Hook - Will run before scenario
Before ('@AllWhoIsScenarios') do
  # Reading base URL for this feature
  $baseURL = $config_xml.cucumberconfig.features.feature(:css => "[name='WhoIs']").baseurl.content 
end

# Tagged Scenario Hook - Will run before scenario
Before ('@AllDeliciousScenarios') do
  # Reading the base URL from config file
  $baseURL = $config_xml.cucumberconfig.features.feature(:css => "[name='delicious']").baseurl.content
end

# Tagged Scenario Hook - Will run before scenario
Before ('@usercreateservice') do

  # Reading the base URL from config file
  $baseURL = $config_xml.cucumberconfig.features.feature(:css => "[name='usercreate']").baseurl.content
  
  # Read headers
  @headerNames = ""
  @headerValues = ""
  $config_xml.cucumberconfig.features.feature(:css => "[name='usercreate']").headers.header.each do |head|
    tagarray = head.text.split(",")
    @headerNames = @headerNames + tagarray[0] + ";"
    @headerValues = @headerValues + tagarray[1] + ";"
  end
end


# Before scenario hook - will get executed before every scenario
Before do
if ($oldbaseurl != $baseURL)  
  if ($firstfeature == 0)
    $htmlEMailContent = $htmlEMailContent + "</table>"
  end
  #Constructing Email body
  $firstfeature = 0
  @htmlEMailCnt = $htmlEMailContent + "<br><b><font color = \"blue\">Feature Name: Testing of " + $baseURL + " API" + "</font><br><br>"
  @htmlEMailCnt = @htmlEMailCnt + "<Table border=\"1\">"
  @htmlEMailCnt = @htmlEMailCnt + "<tr bgcolor=\"aqua\">"
  @htmlEMailCnt = @htmlEMailCnt + "<th>S.No</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Snenario Name</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Request URL</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Method</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Response</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Tags verified</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Tags missing</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Format</th>"
  @htmlEMailCnt = @htmlEMailCnt + "<th>Result</th></tr>"
  $htmlEMailContent = @htmlEMailCnt
  $sno  = 0
  $oldbaseurl = $baseURL
end
  @htmlEMailCnt = $htmlEMailContent
  @baseurl = $baseURL
end

# Step hook - will be executed after each cucumber step to log the execution
AfterStep do
 if (@logtext.length > 0)
  $msgLog.logtext @logtext
 end
end

# After Scenario hook - will be executed after end of each scenario
After do |scenario|
  
  if (@result == "Pass")
     respart = "<td><font color=\"green\">PASS</font></td>"
  else
     respart = "<td><font color=\"red\">FAIL</font></td>"
  end
  if (@format == nil)
    @format = "--"
  end
  if (@tagsverified.length == 0)
    @tagsverified = "--"
  end
  if (@tagsmissing.length == 0)
    @tagsmissing = "--"
  end
  
  if (@casename == nil)
    scenariodesc = " "
  else
    scenariodesc = "(#{@casename})"
  end
  # Senario Serial number counter
  $sno = $sno + 1
  
  @scenarioresult = "<tr><td>" + $sno.to_s() + "</td><td>Testing of " + @endurl + scenariodesc + "</td><td>" + @baseurl + "</td><td>" + @method + "</td><td>" + @response.code.to_s() + "-" + @response.message + "</td><td>" + @tagsverified + "</td><td>" + @tagsmissing + "</td><td>" + @format + "</td>" + respart + "</tr>"
  @htmlEMailCnt = @htmlEMailCnt + @scenarioresult
  $htmlEMailContent = @htmlEMailCnt
end

# End of global hook
at_exit do  
  if ENV['EMAIL_REPORT'] == "ON"
    EmailConfig = EmailSetupReader.new
    puts "The script execution is logged in WebServiceTesting.log"
    emailer = Emailsender.new    
    emailer.sendemail($htmlEMailContent, EmailConfig.email_server, EmailConfig.email_port, EmailConfig.email_from, EmailConfig.email_to)
    puts "Notification email sent!"
  end
end