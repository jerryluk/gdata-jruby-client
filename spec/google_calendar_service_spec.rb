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
  
  # Commented out if you run this test case too many times which will hit
  # the API throttle limit
  it "should be able to create, update and delete new calendars" do   
    # Create a new calendar
    calendar = GData::CalendarEntry.new(
      :title => "New Calendar".to_plain_text,
      :summary => "This is a new Calendar.".to_plain_text,
      :time_zone => GData::TimeZoneProperty.new('America/Los_Angeles'),
      :hidden => GData::HiddenProperty::FALSE,
      :color => GData::ColorProperty.new('#2952A3'))
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
    event = GData::CalendarEventEntry.new(
      :title => 'New Event'.to_plain_text,
      :content => 'New Content'.to_plain_text)
    event_time = GData::When.new(
      :start_time => Time.local(2010, "dec", 25, 20, 0, 0),
      :end_time => Time.local(2010, "dec", 25, 21, 0, 0))
    event.add_time(event_time)
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    event.id.should_not be_nil
    
    event.title = 'New Title'.to_plain_text
    event = event.update
    event.title.plain_text.should == 'New Title'
    
    lambda do
      event.delete
    end.should_not raise_error
  end
  
  it "should able to quick add an event" do
    event = GData::CalendarEventEntry.new(
      :content => "Say Hi to Jerry Oct 31, 2010 12pm-1pm".to_plain_text,
      :quick_add => true)
    
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    
    event.id.should_not be_nil
    
    event.title.plain_text.should == "Say Hi to Jerry"
    start_time = Time.from_joda_time(event.times.first.start_time)
    start_time.should == Time.local(2010, 10, 31, 12, 0, 0, "-07:00", nil)
    
    lambda do
      event.delete
    end.should_not raise_error
  end
  
  it "should be able to create recurring events" do
    recur_data = "DTSTART;VALUE=DATE:20070501\n" + 
                 "DTEND;VALUE=DATE:20070502\n" + 
                 "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904"
    recur = GData::Recurrence.new(recur_data)
    event = GData::CalendarEventEntry.new(:recurrence => recur)
    
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    
    event.id.should_not be_nil
    event.recurrence.value.should == recur_data
    
    lambda do
      event.delete
    end.should_not raise_error
  end
  
  # Copied from Google: When working with batch requests, the size of the request must be 
  # under a megabyte and it's best to limit batches to 50-100 operations at a time.
  it "should be able to perform multiple operations with a batch request" do
    # Create a test calendar so this test case won't have dependency on the test account
    calendar = GData::CalendarEntry.new(:title => "Test Calendar".to_plain_text)
    calendar = @service.create_entry(:url => GData::CalendarService::OWN_CALENDAR_URL, 
      :entry => calendar)
    calendar_url = calendar.get_link(nil, nil).href
    
    # Create some events
    1.upto 3 do |i|
      event = GData::CalendarEventEntry.new(:title => "Test Event #{i}".to_plain_text)
      event = @service.create_entry(:url => calendar_url, :entry => event)
    end
    
    # Give it a small delay such that the changes is propagated
    sleep(2)
    
    # Get some events to operate on
    feed = @service.find_feed(:url => calendar_url)
    
    insert_event = GData::CalendarEventEntry.new(:title => 'first batch event'.to_plain_text)
    GData::BatchUtils.set_batch_id(insert_event, "1")
    GData::BatchUtils.set_batch_operation_type(insert_event, GData::BatchOperationType::INSERT)
    
    query_event = feed.entries[0]
    GData::BatchUtils.set_batch_id(query_event, "2")
    GData::BatchUtils.set_batch_operation_type(query_event, GData::BatchOperationType::QUERY)
    
    update_event = feed.entries[1]
    update_event.title = 'update via batch'.to_plain_text
    GData::BatchUtils.set_batch_id(update_event, "3")
    GData::BatchUtils.set_batch_operation_type(update_event, GData::BatchOperationType::UPDATE)
    
    delete_event = feed.entries[2]
    GData::BatchUtils.set_batch_id(delete_event, "4")
    GData::BatchUtils.set_batch_operation_type(delete_event, GData::BatchOperationType::DELETE)
    
    batch_request = GData::CalendarEventFeed.new
    batch_request.entries << insert_event
    batch_request.entries << query_event
    batch_request.entries << update_event
    batch_request.entries << delete_event
    
    # Get the batch link URL and send the batch request there
    batch_url = feed.get_link(GData::Link::Rel::FEED_BATCH, GData::Link::Type::ATOM).href
    batch_response = @service.create_batch(:url => batch_url, :feed => batch_request)
    
    batch_response.entries.each do |entry|
      unless GData::BatchUtils.success?(entry)
        batch_id = GData::BatchUtils.getBatchId(entry)
        status = GData::BatchUtils.getBatchStatus(entry)
        puts "#{batch_id} failed (#{status.reason}) #{status.content}"
      end
      GData::BatchUtils.success?(entry).should == true
    end
    
    # Clean up
    sleep(3)
    calendar.delete
  end
  
  it "should be able to add extented properties to the event" do
    event = GData::CalendarEventEntry.new(
      :title => 'New Event'.to_plain_text,
      :content => 'New Content'.to_plain_text)
    event_time = GData::When.new(
      :start_time => Time.local(2010, "dec", 25, 20, 0, 0),
      :end_time => Time.local(2010, "dec", 25, 21, 0, 0))
    event.add_time(event_time)
    
    property = GData::ExtendedProperty.new(
      :name => 'http://schemas.presdo.com/2009#event.id',
      :value => '1234')
    event.add_extended_property(property)
    
    event = @service.create_entry(:url => GData::CalendarService::DEFAULT_CALENDAR_URI, 
      :entry => event)
    event.id.should_not be_nil
    
    event.extended_properties.first.name.should == 'http://schemas.presdo.com/2009#event.id'
    event.extended_properties.first.value.should == '1234'
    
    lambda do
      event.delete
    end.should_not raise_error
  end

  describe "Retrieving events" do
    before(:all) do
      create_service
      
      @calendar = GData::CalendarEntry.new(
        :title => "Test Calendar".to_plain_text,
        :time_zone => GData::TimeZoneProperty.new('America/Los_Angeles'))
      @calendar = @service.create_entry(:url => GData::CalendarService::OWN_CALENDAR_URL, 
        :entry => @calendar)
      @calendar_url = @calendar.get_link(nil, nil).href
      
      @event = GData::CalendarEventEntry.new(:title => 'Test Event'.to_plain_text)
      @event_time = GData::When.new(
        :start_time => Time.local(2010, "dec", 25, 20, 0, 0), 
        :end_time => Time.local(2010, "dec", 25, 21, 0, 0))
      @event.add_time(@event_time)
      @event = @service.create_entry(:url => @calendar_url, :entry => @event)
    end
    
    after(:all) do
      sleep(3)
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
      query = GData::CalendarQuery.new(
        :url => @calendar_url,
        :minimum_start_time => Time.local(2010, "dec", 25, 0, 0, 0),
        :maximum_start_time => Time.local(2010, "dec", 26, 0, 0, 0))
      
      feed = @service.find_feed(:query => query)
      feed.should_not be_nil
      entries = feed.entries
      entries.size.should == 1
      entries.first.id.should == @event.id
      
      query = GData::CalendarQuery.new(@calendar_url)
      query.minimum_start_time = Time.local(2010, "dec", 20, 0, 0, 0).to_joda_time
      query.maximum_start_time = Time.local(2010, "dec", 21, 0, 0, 0).to_joda_time
      
      feed = @service.find_feed(:query => query)
      feed.should_not be_nil
      feed.entries.size.should == 0
    end
    
    it "should retrieve events matching a full text query" do
      query = GData::CalendarQuery.new(
        :url => @calendar_url,
        :full_text_query => "Test Event")
      
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