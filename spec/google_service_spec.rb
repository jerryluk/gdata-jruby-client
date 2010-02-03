require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'
require File.dirname(__FILE__) + '/google_keys.rb'

include GoogleHelpers

describe GData::GoogleService do
  it "should able to raise the right exception" do
    e = GData.gdata_exception_for(Exception.new("com.google.gdata.util.AuthenticationException: Token invalid - Invalid AuthSub token."))
    e.should be_instance_of(GData::AuthenticationError)
  end
end