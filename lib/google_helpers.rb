module GoogleHelpers
  include_class 'java.net.URL'
  
  def url_for(url_or_string)
    (url_or_string.kind_of? String) ? URL.new(url_or_string) : url_or_string
  end
  
  def update_attributes(attributes)
    attributes.each do |k, v|
      self.send("#{k}=".to_sym, (v.kind_of? Time)? v.to_joda_time : v)
    end
  end
  
end