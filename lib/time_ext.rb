require 'parsedate'

class Time
  include_class('com.google.gdata.data.DateTime') {|package,name| "G#{name}" }
  
  def to_gdata
    to_gdata_date_time
  end
  
  def to_gdata_date_time
    GDateTime.parseDateTime(self.iso8601)
  end
  
  def self.from_gdata(gdatetime)
    self.from_gdata_date_time(gdatetime)
  end
  
  def self.from_gdata_date_time(gdatetime)
    if defined? parse
      self.parse(gdatetime.to_s)
    else
      res = ParseDate.parsedate(gdatetime.to_s)
      Time.local(*res)
    end
  end
  
  unless defined? iso8601
    # The following are copied from Rails. If you are using Rails, everything
    # is already defined in ActiveSupport
    def iso8601(fraction_digits = 0)
      fraction = if fraction_digits > 0
        ".%i" % self.usec.to_s[0, fraction_digits]
      end
      "#{self.strftime("%Y-%m-%dT%H:%M:%S")}#{fraction}#{formatted_offset(true, 'Z')}"
   end
   
    def formatted_offset(colon = true, alternate_utc_string = nil)
      utc? && alternate_utc_string || to_utc_offset_s(utc_offset, colon)
    end
    
    def to_utc_offset_s(utc_offset, colon=true)
      seconds = utc_offset
      sign = (seconds < 0 ? -1 : 1)
      hours = seconds.abs / 3600
      minutes = (seconds.abs % 3600) / 60
      "%+03d%s%02d" % [ hours * sign, colon ? ":" : "", minutes ]
    end
  end
end