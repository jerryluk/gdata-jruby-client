require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.dirname(__FILE__) + '/../lib/gdata_jruby_client'
require File.dirname(__FILE__) + '/google_keys.rb'

include GoogleHelpers

describe GData::ContactsService do
  NO_YOMI = nil
  
  before(:each) do
    create_service
  end
  
  it "should able to create, update, and delete a contact" do
    name = GData::Name.new
    name.full_name = GData::FullName.new('Full Name', NO_YOMI)
    name.given_name = GData::GivenName.new('First', NO_YOMI)
    name.family_name = GData::FamilyName.new('Last', NO_YOMI)
    
    contact = GData::ContactEntry.new(:name => name, :content => 'Test contact'.to_plain_text)
    
    email = GData::Email.new(:address => 'test@gmail.com', 
                             :rel => 'http://schemas.google.com/g/2005#home',
                             :primary => true)
    contact.add_email_address email
    
    # Create a new contact
    contact = @service.create_entry(:url => GData::ContactsService::DEFAULT_CONTACTS_URI, 
      :entry => contact)
    contact.id.should_not be_nil
    contact.email_addresses.first.address.should == 'test@gmail.com'
    
    #Update a new contact
    contact.content = "New Content".to_plain_text
    contact = contact.update 
    contact.content.plain_text.should == "New Content"
    
    # Delete the contact
    lambda do
      contact.delete
    end.should_not raise_error
    
    feed = @service.find_feed(:url => GData::ContactsService::DEFAULT_CONTACTS_URI)
    entries = feed.entries
    entries.each do |e|
      e.id.should_not == contact.id
    end
  end
  
  describe "Retrieving contacts" do
    before(:all) do
      create_service
      @now = Time.new
      @name = GData::Name.new
      @name.full_name = GData::FullName.new('Sergey Bin', NO_YOMI)
      @name.given_name = GData::GivenName.new('Sergey', NO_YOMI)
      @name.family_name = GData::FamilyName.new('Bin', NO_YOMI)

      @contact = GData::ContactEntry.new(:name => @name, :content => 'Google CoFounder'.to_plain_text)

      @email = GData::Email.new(:address => 'sergey@google.com', 
                                :rel => 'http://schemas.google.com/g/2005#work',
                                :primary => true)
      @contact.add_email_address @email
      
      @im = GData::Im.new(
        :address => 'sergey@google.com', 
        :rel => 'http://schemas.google.com/g/2005#other', 
        :protocol => 'http://schemas.google.com/g/2005#MSN')
        
      @contact.add_im_address @im
      
      @contact = @service.create_entry(:url => GData::ContactsService::DEFAULT_CONTACTS_URI, 
        :entry => @contact)
      
      # Add a photo to the contact
      photo = open(File.dirname(__FILE__) + '/images/sergey.jpg', 'rb') { |io| io.read }
      photo_url = @contact.contact_photo_link.href
      request = @service.create_request(GData::ContactsService::GDataRequest::RequestType::UPDATE,
        url_for(photo_url), GData::ContentType.new('image/jpeg'))
      request_stream = request.request_stream
      request_stream.write(photo.to_java_bytes)
      request.execute
    end
    
    def assert_contact(c)
      c.name.full_name.value.should == @name.full_name.value
      c.name.given_name.value.should == @name.given_name.value
      c.name.family_name.value.should == @name.family_name.value
      c.email_addresses.first.address.should == @email.address
      c.im_addresses.first.address.should == @im.address
      c.contact_photo_link.href.should_not be_nil
      c.contact_photo_link.etag.should_not be_nil
      
      # Read the photo
      # stream = @service.get_stream_from_link(c.contact_photo_link)
      # photo = open(File.dirname(__FILE__) + '/images/sergey_out.jpg', 'wb') do |f|
      #   while (byte = stream.read) > -1
      #     f << byte.chr
      #   end
      # end
      
      # Now we know c is @contact, assign c to @contact so it has updated information (photo)
      @contact = c
    end
    
    it "should able to retrieve all contacts" do
      found_contact = false
      feed = @service.find_feed(:url => GData::ContactsService::DEFAULT_CONTACTS_URI)
      feed.should_not be_nil
      entries = feed.entries
      entries.size.should > 0
      entries.each do |e|
        if e.id == @contact.id
          found_contact = true
          assert_contact(e)
        end
      end
      found_contact.should be_true
    end
    
    it "should able to retrieve contacts using query parameters" do
      query = GData::Query.new(
        :url => GData::ContactsService::DEFAULT_CONTACTS_URI,
        :updatedMin => @now)
      entries = @service.find_feed(:query => query).entries
      entries.size.should == 1
      assert_contact(entries.first)
    end
    
    after(:all) do
      @contact.delete
    end
  
  end
  
  def create_service
    @service = GData::ContactsService.new DEFAULT_APPLICATION_NAME
    # Use OAuth
    credentials = GData::GoogleOAuthParameters.new
    credentials.attributes = {
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :token => TOKEN,
      :token_secret => TOKEN_SECRET }
    @service.oauth_credentials = credentials
    # Use AuthSubToken
    # @service.auth_sub_token = SESSION_TOKEN
    @service
  end
  
end