require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'

include GoogleHelpers

describe GData::Entry do
  it "should able to initialize a new entry without attributes" do
    entry = GData::CalendarEventEntry.new
    entry.title = 'New Title'.plain_text
    
    entry.title.plain_text.should == 'New Title'
  end
  
  it "should able to initialize a new entry with attributes" do
    entry = GData::CalendarEventEntry.new({
      :title => 'New Title'.to_plain_text,
      :content => 'New Content'.to_plain_text })
    
    entry.title.plain_text.should == 'New Title'
    entry.content.plain_text.should == 'New Content'
  end
end