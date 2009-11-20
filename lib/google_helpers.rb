module GoogleHelpers
  include_class 'java.net.URL'
  
  def url_for(url_or_string)
    (url_or_string.kind_of? String) ? URL.new(url_or_string) : url_or_string
  end
  
  
end