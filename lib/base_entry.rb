class Java::ComGoogleGdataData::BaseEntry
  alias_method :orig_initialize, :initialize
  
  def initialize(options=nil)
    if options.is_a? Hash
      orig_initialize()
      update_attributes(options)
    else
      orig_initialize()
    end
  end
  
  def update_attributes(attributes)
    attributes.each do |k, v|
      self.send("#{k}=".to_sym, (v.respond_to? :to_gdata)? v.to_gdata : v)
    end
  end
  
  def id
    get_id
  end
end