module GData
  include_package 'com.google.gdata.data.contacts'
  include_package 'com.google.gdata.client.contacts'
  include_package 'com.google.gdata.data.extensions'
end

class Java::ComGoogleGdataClientContacts::ContactsService
  DEFAULT_CONTACTS_URI = 'http://www.google.com/m8/feeds/contacts/default/full'
  
  def find_feed(options)
    super(options.merge({:class => GData::ContactFeed}))
  end
  
  def find_entry(options)
    super(options.merge({:class => GData::ContactEntry}))
  end
end