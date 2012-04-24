$LOAD_PATH << './lib'
require 'logger'
require 'log.rb'
require 'email_sender.rb'
require 'rubygems'
require 'pony'

# Logging (Begin Global Hook)
$LOG = Logger.new('log/WebServiceTesting.log', 'daily')
$msgLog = Log.new
$htmlEMailContent = ""
$sno=0
$htmlEMailContent = "<html><body><hr><h1>Cucumber webservice testing results</h1><b>Date: " + Time.now.strftime("%m-%d-%Y %H:%M:%S") + "</b><hr>"

# End of global hook
at_exit do
 puts "The script execution is logged in WebServiceTesting.log"
 emailer = Emailsender.new
 emailer.sendemail($htmlEMailContent)
 puts "Notification email sent!"
end