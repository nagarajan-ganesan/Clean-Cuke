$LOAD_PATH << './features/lib'
require 'logger'
require 'log.rb'
require 'email_sender.rb'
require 'rubygems'
require 'pony'
require 'nokogiri'
require 'httparty'
require 'json'
require 'pp'
require 'rexml/document'
require 'uri'

# Logging (Begin Global Hook)
$LOG = Logger.new('WebServiceTesting.log', 'daily')
$msgLog = Log.new
$htmlEMailContent = ""
$sno=0
$oldbaseurl = ""
$firstfeature = 1
$htmlEMailContent = "<html><body><hr><h1>Cucumber webservice testing results</h1><b>Date: " + Time.now.strftime("%m-%d-%Y %H:%M:%S") + "</b><hr>"

# Reading the config XML file using nokogiri
f = File.open("config/config.xml")
fcont = f.read
$config_xml = Nokogiri::Slop fcont

class EmailSetupReader
  attr_reader :email_server
  attr_reader :email_port
  attr_reader :email_from
  attr_reader :email_to
  def initialize
    @email_server = $config_xml.cucumberconfig.emailsetup.emailserver.text
    @email_port = $config_xml.cucumberconfig.emailsetup.emailport.text
    @email_from = $config_xml.cucumberconfig.emailsetup.from.text
    @email_to = $config_xml.cucumberconfig.emailsetup.to.text
  end
end
