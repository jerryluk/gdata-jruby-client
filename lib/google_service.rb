class Java::ComGoogleGdataClient::GoogleService
  include_class 'java.net.URL'
  alias_method :orig_get_feed, :get_feed
  alias_method :orig_insert, :insert
  
  def oauth_credentials=(credientials, signer=GData::OAuthHmacSha1Signer.new)
    self.set_oauth_credentials(credientials, signer)
  end
  
  def get_feed(url, feed_java_class)
    url = (url.kind_of? String) ? URL.new(url) : url
    self.orig_get_feed(url, feed_java_class)
  end
  
  def get_feed_with_url(url, feed_java_class)
    self.orig_get_feed(URL.new(url), feed_java_class)
  end
  
  def insert(url, entry)
    url = (url.kind_of? String) ? URL.new(url) : url
    self.orig_insert(url, entry)
  end
  
end
