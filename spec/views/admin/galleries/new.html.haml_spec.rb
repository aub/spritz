require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/galleries/new.html.haml" do
  include Admin::GalleriesHelper
  
  before(:each) do
    @gallery = mock_model(Gallery)
    @gallery.stub!(:new_record?).and_return(true)
    @gallery.stub!(:name).and_return("MyString")
    @gallery.stub!(:address).and_return("MyString")
    @gallery.stub!(:city).and_return("MyString")
    @gallery.stub!(:state).and_return("MyString")
    @gallery.stub!(:zip).and_return("MyString")
    @gallery.stub!(:phone).and_return("MyString")
    @gallery.stub!(:email).and_return("MyString")
    @gallery.stub!(:url).and_return("MyString")
    @gallery.stub!(:country).and_return("MyString")
    @gallery.stub!(:description).and_return("MyString")
    assigns[:gallery] = @gallery
  end

  it "should render new form" do
    render "/admin/galleries/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_galleries_path) do
      with_tag("input#gallery_name[name=?]", "gallery[name]")
      with_tag("input#gallery_address[name=?]", "gallery[address]")
      with_tag("input#gallery_city[name=?]", "gallery[city]")
      with_tag("input#gallery_state[name=?]", "gallery[state]")
      with_tag("input#gallery_zip[name=?]", "gallery[zip]")
      with_tag("input#gallery_phone[name=?]", "gallery[phone]")
      with_tag("input#gallery_email[name=?]", "gallery[email]")
      with_tag("input#gallery_url[name=?]", "gallery[url]")
    end
  end
end


