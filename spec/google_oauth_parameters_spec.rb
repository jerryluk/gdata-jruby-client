require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'
require File.dirname(__FILE__) + '/google_keys.rb'

describe GData::CalendarService do
  
  it "should able to assign credentials attributes" do
    credentials = GData::GoogleOAuthParameters.new
    credentials.attributes = {
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :token => TOKEN,
      :token_secret => TOKEN_SECRET }
    credentials.oauth_consumer_key.should == CONSUMER_KEY
    credentials.oauth_consumer_secret.should == CONSUMER_SECRET
    credentials.oauth_token.should == TOKEN
    credentials.oauth_token_secret.should == TOKEN_SECRET
  end
  
end