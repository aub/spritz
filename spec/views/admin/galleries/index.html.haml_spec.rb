require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/galleries/index.html.haml" do
  include Admin::GalleriesHelper
  
  before(:each) do
    gallery_98 = mock_model(Gallery)
    gallery_98.should_receive(:name).and_return("MyString")
    gallery_99 = mock_model(Gallery)
    gallery_99.should_receive(:name).and_return("MyString")

    assigns[:galleries] = [gallery_98, gallery_99]
  end

  it "should render list of admin_galleries" do
    render "/admin/galleries/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
  end
end

