Dir.glob("#{File.dirname(__FILE__)}/gdata/java/deps/*.jar").each do |j|
  require j
end

Dir.glob("#{File.dirname(__FILE__)}/gdata/java/lib/*.jar").each do |j|
  require j
end

module GData
  class AuthenticationError < Exception; end
  class ServiceForbidden < Exception; end
  class ResourceNotFound < Exception; end
  
  def self.gdata_exception_for(e)
    case e.message
    when /AuthenticationException/
      AuthenticationError.new(e.message)
    when /ServiceForbiddenException/
      ServiceForbidden.new(e.message)
    when /ResourceNotFoundException/
      ResourceNotFound.new(e.message)
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