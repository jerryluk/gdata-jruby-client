module GData
  include_package 'com.google.gdata.data.calendar'
  include_package 'com.google.gdata.client.calendar'
  include_package 'com.google.gdata.data.extensions'
end

class Java::ComGoogleGdataClientCalendar::CalendarService
  ALL_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/allcalendars/full'
  OWN_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/owncalendars/full'
  DEFAULT_CALENDAR_URI = 'http://www.google.com/calendar/feeds/default/private/full'
  
  def find_feed(options)
    super(options.merge({:class => GData::CalendarFeed}))
  end
  
  def find_entry(options)
    super(options.merge({:class => GData::CalendarEntry}))
  end
end