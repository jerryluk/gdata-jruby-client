Dir.glob("#{File.dirname(__FILE__)}/gdata/java/deps/*.jar").each do |j|
  require j
end

Dir.glob("#{File.dirname(__FILE__)}/gdata/java/lib/*.jar").each do |j|
  require j
end

module GData
  class GeneralException < Exception; end
  class AuthenticationException < Exception; end
  class ServiceForbiddenException < Exception; end
  class ResourceNotFoundException < Exception; end
  
  def self.gdata_exception_for(e)
    case e.message
    when /AuthenticationException/
      AuthenticationException.new(e.message)
    when /ServiceForbiddenException/
      ServiceForbiddenException.new(e.message)
    when /ResourceNotFoundException/
      ResourceNotFoundException.new(e.message)
    else
      e
    end
  end
  
  include_package 'com.google.gdata.data'
  include_package 'com.google.gdata.data.acl'
  include_package 'com.google.gdata.data.batch'
  include_package 'com.google.gdata.util'
  include_package 'com.google.gdata.client'
  include_package 'com.google.gdata.client.authn.oauth'
  include_package 'com.google.gdata.client.http'
end