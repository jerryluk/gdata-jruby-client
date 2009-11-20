class Java::ComGoogleGdataClient::GoogleService
  include GoogleHelpers
  
  def oauth_credentials=(credientials, signer=GData::OAuthHmacSha1Signer.new)
    self.set_oauth_credentials(credientials, signer)
  end
  
  def find_feed(options={})
    raise "URL or query is required" unless options[:url] or option[:query]
    raise "Feed Class is required" unless options[:class]
    options[:url] = url_for(options[:url]) if options[:url]
    
    if options[:etag] or options[:modified_since]
      get_feed(options[:url] || options[:query], 
        options[:class].java_class, 
        options[:etag] || options[:modified_since])
    else
      get_feed(options[:url] || options[:query], 
        options[:class].java_class)
    end
  end
  
  def find_entry(options={})
    raise "URL or query is required" unless options[:url] or option[:query]
    raise "Entry Class is required" unless options[:class]
    options[:url] = url_for(options[:url]) if options[:url]
    
    if options[:etag] or options[:modified_since]
      get_entry(options[:url] || options[:query], 
        options[:class].java_class, 
        options[:etag] || options[:modified_since])
    else
      get_entry(options[:url] || options[:query], 
        options[:class].java_class)
    end
  end
  
  def create(options={})
    raise "Feed URL is required" unless options[:url]
    raise "Entry is required" unless options[:entry]
    options[:url] = url_for(options[:url]) if options[:url]
    
    insert(options[:url], options[:entry])
  end
  
end
