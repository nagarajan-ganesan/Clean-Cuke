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

def initialize
  @email_server = $config_xml.cucumberconfig.emailsetup.emailserver.text
end

def initialize
    @email_port = $config_xml.cucumberconfig.emailsetup.emailport.text
end

def initialize
  @email_from = $config_xml.cucumberconfig.emailsetup.from.text
end

def initialize
  @email_to = $config_xml.cucumberconfig.emailsetup.to.text
end
