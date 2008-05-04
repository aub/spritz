require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/contacts/show.html.haml" do
  include Admin::ContactsHelper
  
  before(:each) do
    @contact = mock_model(Contact)
    @contact.stub!(:name).and_return("MyString")
    @contact.stub!(:email).and_return("MyString")
    @contact.stub!(:phone).and_return("MyString")
    @contact.stub!(:message).and_return("MyText")

    assigns[:contact] = @contact
  end

  it "should render attributes in <p>" do
    render "/admin/contacts/show.html.haml"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyText/)
  end
end

