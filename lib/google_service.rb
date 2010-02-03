class Java::ComGoogleGdataClient::GoogleService
  include GoogleHelpers
  
  def oauth_credentials=(credientials, signer=GData::OAuthHmacSha1Signer.new)
    self.set_oauth_credentials(credientials, signer)
  end
  
  def auth_sub_token=(options)
    options = {:private_key => nil}.merge(options)
    self.set_auth_sub_token(options[:token], options[:private_key])
  end
  
  def find_feed(options={})
    raise "URL or query is required" unless options[:url] or options[:query]
    raise "Feed Class is required" unless options[:class]
    options[:url] = url_for(options[:url]) if options[:url]
    
    begin
      if options[:etag] or options[:modified_since]
        get_feed(options[:url] || options[:query], 
          options[:class].java_class, 
          options[:etag] || options[:modified_since])
      else
        get_feed(options[:url] || options[:query], 
          options[:class].java_class)
      end
    rescue NativeException => e
      e = GData.gdata_exception_for(e)
      return nil if e.is_? ResourceNotFoundException
      raise e
    end
  end
  
  def find_entry(options={})
    raise "URL or query is required" unless options[:url] or option[:query]
    raise "Entry Class is required" unless options[:class]
    options[:url] = url_for(options[:url]) if options[:url]
    
    begin
      if options[:etag] or options[:modified_since]
        get_entry(options[:url] || options[:query], 
          options[:class].java_class, 
          options[:etag] || options[:modified_since])
      else
        get_entry(options[:url] || options[:query], 
          options[:class].java_class)
      end
    rescue NativeException => e
      e = GData.gdata_exception_for(e)
      return nil if e.is_? ResourceNotFoundException
      raise e
    end
  end
  
  def create_entry(options={})
    raise "Feed URL is required" unless options[:url]
    raise "Entry is required" unless options[:entry]
    options[:url] = url_for(options[:url]) if options[:url]
    insert(options[:url], options[:entry])
  rescue NativeException => e
    raise GData.gdata_exception_for(e)
  end
  
  def delete_entry(options={})
    raise "Entry URL is required" unless options[:url]
    options[:url] = url_for(options[:url]) if options[:url]
    
    delete(options[:url])
  end
  
  def create_batch(options={})
    raise "Feed URL is required" unless options[:url]
    raise "Feed is required" unless options[:feed]
    options[:url] = url_for(options[:url]) if options[:url]
    
    batch(options[:url], options[:feed])
  rescue NativeException => e
    raise GData.gdata_exception_for(e)
  end
  
end
