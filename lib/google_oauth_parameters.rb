module GData
  include_package 'com.google.gdata.client.authn.oauth'
end

class Java::ComGoogleGdataClientAuthnOauth::GoogleOAuthParameters
  def attributes=(credentials = {})    
    self.oauth_consumer_key = credentials[:consumer_key] if credentials[:consumer_key]
    self.oauth_consumer_secret = credentials[:consumer_secret] if credentials[:consumer_secret]
    self.oauth_token = credentials[:token] if credentials[:token]
    self.oauth_token_secret = credentials[:token_secret] if credentials[:token_secret]
    self
  end
end