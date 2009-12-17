class String
  include_class 'com.google.gdata.data.PlainTextConstruct'
  
  def to_gdata
    to_plain_text
  end
  
  def to_plain_text
    PlainTextConstruct.new(self)
  end
end