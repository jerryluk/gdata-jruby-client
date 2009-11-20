module GData
  include_package 'com.google.gdata.data.calendar'
  include_package 'com.google.gdata.client.calendar'
end

class Java::ComGoogleGdataClientCalendar::CalendarService
  def fetch_feed(url)
    self.get_feed_with_url(url, GData::CalendarFeed.java_class)
  end
end


class GoogleCalendarService
  ALL_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/allcalendars/full'
  OWN_CALENDAR_URL = 'http://www.google.com/calendar/feeds/default/owncalendars/full'
  DEFAULT_CALENDAR_URI = 'http://www.google.com/calendar/feeds/default/private/full'
end