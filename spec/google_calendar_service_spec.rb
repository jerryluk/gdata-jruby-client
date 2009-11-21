require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'
require File.dirname(__FILE__) + '/google_keys.rb'

include GoogleHelpers

describe GData::CalendarService do
  
  before(:each) do
    create_service
  end
  
  it "should able to retrieving all calendars" do
    feed = @service.find_feed(:url => GData::CalendarService::ALL_CALENDAR_URL)
    feed.should_not be_nil
    entries = feed.entries
    entries.size.should > 0
    entries.each do |e|
      e.title.plain_text.should_not be_nil
    end
  end
  
  it "should able to retrieving own calendars" do
    feed = @service.find_feed(:url => GData::CalendarService::OWN_CALENDAR_URL)
    feed.should_not be_nil
    entries = feed.entries
    entries.size.should > 0
    entries.each do |e|
      e.title.plain_text.should_not be_nil
    end
  end
  
  it "should be able to create, update and delete new calendars" do   
    # Create a new calendar
    calendar = GData::CalendarEntry.new
    calendar.title = "New Calendar".to_gdata
    calendar.summary = "This is a new Calendar.".to_gdata
    calendar.time_zone = GData::TimeZoneProperty.new('America/Los_Angeles')
    calendar.hidden = GData::HiddenProperty::FALSE
    calendar.color = GData::ColorProperty.new('#2952A3')
    calendar.add_location GData::Where.new("", "", "Palo Alto")
    
    calendar = @service.create_entry(:url => GData::CalendarService::OWN_CALENDAR_URL, 
      :entry => calendar)
    calendar.should_not be_nil
    calendar.id.should_not be_nil
    calendar.title.plain_text.should == "New Calendar"
    
    #Update a new calendar
    calendar.title = "New Title".to_gdata
    calendar = calendar.update 
    calendar.title.plain_text.should == "New Title"
    
    # Delete the calendar
    lambda do
      calendar.delete
    end.should_not raise_error
    
    feed = @service.find_feed(:url => GData::CalendarService::OWN_CALENDAR_URL)
    entries = feed.entries
    entries.each do |e|
      e.id.should_not == calendar.id
    end
  end
  
  it "should be able to create, update, and delete events" do
    event = GData::CalendarEventEntry.new
    event.title = 'New Event'.to_gdata
    event.content = 'New Content'.to_gdata
    event_time = GData::When.new
    event_time.start_time = Time.local(2010, "dec", 25, 20, 0, 0).to_gdata
    event_time.end_time = Time.local(2010, "dec", 25, 21, 0, 0).to_gdata
    event.add_time(event_time)
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    event.id.should_not be_nil
    
    event.title = 'New Title'.to_gdata
    event = event.update
    event.title.plain_text.should == 'New Title'
    
    lambda do
      event.delete
    end.should_not raise_error
  end
  
  it "should able to quick add an event" do
    event = GData::CalendarEventEntry.new
    event.content = "Say Hi to Jerry Oct 31, 2010 12pm-1pm".to_gdata
    event.quick_add = true
    
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    
    event.id.should_not be_nil
    
    event.title.plain_text.should == "Say Hi to Jerry"
    start_time = Time.from_gdata(event.times.first.start_time)
    start_time.should == Time.local(2010, 10, 31, 12, 0, 0, "-07:00", nil)
    
    lambda do
      event.delete
    end.should_not raise_error
  end

  describe "Retrieving events" do
    before(:all) do
      create_service
      
      @calendar = GData::CalendarEntry.new
      @calendar.title = "Test Calendar".to_gdata
      @calendar.time_zone = GData::TimeZoneProperty.new('America/Los_Angeles')
      @calendar = @service.create_entry(:url => GData::CalendarService::OWN_CALENDAR_URL, 
        :entry => @calendar)
      @calendar_url = @calendar.get_link(nil, nil).href
      
      @event = GData::CalendarEventEntry.new
      @event.title = 'Test Event'.to_gdata
      @event_time = GData::When.new
      @start_time = Time.local(2010, "dec", 25, 20, 0, 0)
      @end_time = Time.local(2010, "dec", 25, 21, 0, 0)
      @event_time.start_time = @start_time.to_gdata
      @event_time.end_time = @end_time.to_gdata
      @event.add_time(@event_time)
      @event = @service.create_entry(:url => @calendar_url, :entry => @event)
    end
    
    after(:all) do
      @event.delete
      @calendar.delete
    end
    
    it "should retrieve events without query parameters" do
      feed = @service.find_feed(:url => @calendar_url)
      feed.should_not be_nil
      entries = feed.entries
      entries.size.should == 1
      entries.first.id.should == @event.id
    end
    
    it "should retrieve events for a specified date range" do
      query = GData::CalendarQuery.new(url_for(@calendar_url))
      query.minimum_start_time = Time.local(2010, "dec", 25, 0, 0, 0).to_gdata
      query.maximum_start_time = Time.local(2010, "dec", 26, 0, 0, 0).to_gdata
      
      feed = @service.find_feed(:query => query)
      feed.should_not be_nil
      entries = feed.entries
      entries.size.should == 1
      entries.first.id.should == @event.id
    end
    
  end
  
  def create_service
    @service = GData::CalendarService.new DEFAULT_APPLICATION_NAME
    credentials = GData::GoogleOAuthParameters.new
    credentials.attributes = {
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :token => TOKEN,
      :token_secret => TOKEN_SECRET }
    @service.oauth_credentials = credentials
    @service
  end
  
end