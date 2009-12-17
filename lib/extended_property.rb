class Java::ComGoogleGdataDataExtensions::ExtendedProperty
  include GoogleHelpers
  
  alias_method :orig_initialize, :initialize
  
  def initialize(options=nil)
    if options.is_a? Hash
      orig_initialize()
      update_attributes(options)
    else
      orig_initialize()
    end
  end
end