class Java::ComGoogleGdataClient::Query
  include GoogleHelpers
  
  def initialize(options)
    if options.is_a? Hash
      super url_for(options.delete(:url))
      update_attributes(options)
    else
      super url_for(options)
    end
  end
end