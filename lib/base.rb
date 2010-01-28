Dir.glob("#{File.dirname(__FILE__)}/gdata/java/deps/*.jar").each do |j|
  require j
end

Dir.glob("#{File.dirname(__FILE__)}/gdata/java/lib/*.jar").each do |j|
  require j
end

module GData
  include_package 'com.google.gdata.data'
  include_package 'com.google.gdata.data.acl'
  include_package 'com.google.gdata.data.batch'
  include_package 'com.google.gdata.util'
  include_package 'com.google.gdata.client'
  include_package 'com.google.gdata.client.authn.oauth'
  include_package 'com.google.gdata.client.http'
end