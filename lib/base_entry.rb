class Java::ComGoogleGdataData::BaseEntry
  include GoogleHelpers
  
  alias_method :orig_initialize, :initialize
  
  def initialize(options=nil)
    if options.is_a? Hash
      orig_initialize()
      update_attributes(options)
    elsif options.nil?
      orig_initialize()
    else
      orig_initialize
    end
  end
  
  def id
    get_id
  end
  
  def link
    get_link(nil, nil)
  end
end