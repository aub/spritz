require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/contacts/index.html.haml" do
  include Admin::ContactsHelper
  
  before(:each) do
    contact_98 = mock_model(Contact)
    contact_98.should_receive(:name).and_return("MyString")
    contact_98.should_receive(:created_at).and_return(Time.now)
    contact_99 = mock_model(Contact)
    contact_99.should_receive(:name).and_return("MyString")
    contact_99.should_receive(:created_at).and_return(Time.now)

    assigns[:contacts] = [contact_98, contact_99]
  end

  it "should render list of contacts" do
    render "/admin/contacts/index.html.haml"
  end
end

