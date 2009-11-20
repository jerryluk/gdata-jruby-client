DEFAULT_APPLICATION_NAME = "Presdo-GDataJRubyClient-0.1"

require 'java'
Dir.glob("#{File.dirname(__FILE__)}/gdata/java/deps/*.jar").each do |j|
  require j
end

Dir.glob("#{File.dirname(__FILE__)}/gdata/java/lib/*.jar").each do |j|
  require j
end

module GData
  include_package 'com.google.gdata.data'
  include_package 'com.google.gdata.data.acl'
  include_package 'com.google.gdata.data.extensions'
  include_package 'com.google.gdata.util'
  include_package 'com.google.gdata.client'
  include_package 'com.google.gdata.client.authn.oauth'
end

require File.dirname(__FILE__) + '/google_helpers'
require File.dirname(__FILE__) + '/base_entry'
require File.dirname(__FILE__) + '/google_oauth_parameters'
require File.dirname(__FILE__) + '/google_service'
require File.dirname(__FILE__) + '/calendar_service'