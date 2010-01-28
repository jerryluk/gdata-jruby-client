module GData
  include_package 'com.google.gdata.data.calendar'
  include_package 'com.google.gdata.client.calendar'
  include_package 'com.google.gdata.data.extensions'
end

class Java::ComGoogleGdataClientCalendar::CalendarService
  ALL_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/allcalendars/full'
  OWN_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/owncalendars/full'
  DEFAULT_CALENDAR_URI = 'http://www.google.com/calendar/feeds/default/private/full'
  
  def find_feed(options, klass = GData::CalendarFeed)
    super(options.merge({:class => klass}))
  end
  
  def find_calendars_feed(options)
    find_feed(options, GData::CalendarFeed)
  end
  
  def find_events_feed(options)
    find_feed(options, GData::CalendarEventFeed)
  end
  
  def find_entry(options, klass = GData::CalendarEntry)
    super(options.merge({:class => klass}))
  end
  
  def find_calendar_entry(options)
    find_entry(options, GData::CalendarEntry)
  end
  
  def find_event_entry(options)
    find_entry(options, GData::CalendarEventEntry)
  end
end