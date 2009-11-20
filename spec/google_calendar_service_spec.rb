require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'
require File.dirname(__FILE__) + '/google_keys.rb'

describe GData::CalendarService do
  include GoogleHelpers
  
  before(:each) do
    @service = GData::CalendarService.new DEFAULT_APPLICATION_NAME
    credentials = GData::GoogleOAuthParameters.new
    credentials.attributes = {
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :token => TOKEN,
      :token_secret => TOKEN_SECRET }
    @service.oauth_credentials = credentials
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
    calendar.title = GData::PlainTextConstruct.new("New Calendar")
    calendar.summary = GData::PlainTextConstruct.new("This is a new Calendar.")
    calendar.time_zone = GData::TimeZoneProperty.new('America/Los_Angeles')
    calendar.hidden = GData::HiddenProperty::FALSE
    calendar.color = GData::ColorProperty.new('#2952A3')
    calendar.add_location GData::Where.new("", "", "Palo Alto")
    
    calendar = @service.create(:url => GData::CalendarService::OWN_CALENDAR_URL, :entry => calendar)
    calendar.should_not be_nil
    calendar.id.should_not be_nil
    calendar.title.plain_text.should == "New Calendar"
    
    #Update a new calendar
    calendar.title = GData::PlainTextConstruct.new("New Title")
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
  
end