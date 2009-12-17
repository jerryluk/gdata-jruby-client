class Java::ComGoogleGdataDataExtensions::Recurrence
  include GoogleHelpers
  
  alias_method :orig_initialize, :initialize
  
  def initialize(value=nil)
    if value.nil?
      orig_initialize
    else
      orig_initialize
      self.value = value 
    end
  end
end