class Java::ComGoogleGdataData::Content
  def method_missing(method_name, *args)
    self.content.send(method_name, *args)
  end
end