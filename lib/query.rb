class Java::ComGoogleGdataClient::Query
  include GoogleHelpers
  
  def initialize(options)
    if options.is_a? Hash
      super url_for(options.delete(:url))
      options.each do |k, v|
        if self.respond_to? "#{k}=".to_sym
          self.send("#{k}=".to_sym, (v.kind_of? Time)? v.to_joda_time : v)
        else
          name = k.to_s.dasherize
          case v
          when Fixnum
            self.set_integer_custom_parameter(name, v)
          when Time
            self.set_string_custom_parameter(name, v.xmlschema)
          else
            self.set_string_custom_parameter(name, v.to_s)
          end
        end
      end
    else
      super url_for(options)
    end
  end
end