$LOAD_PATH << './features/lib'
require 'logger'
require 'log.rb'
require 'email_sender.rb'
require 'rubygems'
require 'pony'
require 'nokogiri'

# Logging (Begin Global Hook)
$LOG = Logger.new('WebServiceTesting.log', 'daily')
$msgLog = Log.new
$htmlEMailContent = ""
$sno=0
$htmlEMailContent = "<html><body><hr><h1>Cucumber webservice testing results</h1><b>Date: " + Time.now.strftime("%m-%d-%Y %H:%M:%S") + "</b><hr>"

# Reading the config XML file using nokogiri
f = File.open("features/config/config.xml")
fcont = f.read
$config_xml = Nokogiri::Slop fcont
email_server = $config_xml.cucumberconfig.emailsetup.emailserver.text
email_port = $config_xml.cucumberconfig.emailsetup.emailport.text
email_from = $config_xml.cucumberconfig.emailsetup.from.text
email_to = $config_xml.cucumberconfig.emailsetup.to.text

# End of global hook
at_exit do
 puts "The script execution is logged in WebServiceTesting.log"
 emailer = Emailsender.new
 emailer.sendemail($htmlEMailContent, email_server, email_port, email_from, email_to)
 puts "Notification email sent!"
end