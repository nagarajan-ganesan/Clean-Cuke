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

# End of global hook
at_exit do
  if ENV['EMAIL_REPORT'] == "ON"
    puts "The script execution is logged in WebServiceTesting.log"
    emailer = Emailsender.new
    emailer.sendemail($htmlEMailContent, @email_server, @email_port, @email_from, @email_to)
    puts "Notification email sent!"
  end
end