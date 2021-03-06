require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/sites/index.html.haml" do
  include Admin::SitesHelper
  
  before(:each) do
    site_98 = mock_model(Site)
    site_98.should_receive(:title).and_return('MyString')
    site_99 = mock_model(Site)
    site_99.should_receive(:title).and_return('MyString')

    assigns[:sites] = [site_98, site_99]
  end

  it "should render list of admin/sites" do
    render "/admin/sites/index.html.haml"
    response.should have_tag("tr>td", "MyString")
  end
end

