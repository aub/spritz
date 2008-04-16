require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/index.html.haml" do
  include Admin::AssetsHelper
  
  before(:each) do
    asset_98 = mock_model(Asset)
    asset_98.should_receive(:content_type).and_return("MyString")
    asset_98.should_receive(:filename).and_return("MyString")
    asset_98.should_receive(:size).and_return("1")
    asset_98.should_receive(:parent_id).and_return("1")
    asset_98.should_receive(:thumbnail).and_return("MyString")
    asset_98.should_receive(:width).and_return("1")
    asset_98.should_receive(:height).and_return("1")
    asset_98.should_receive(:site_id).and_return("1")
    asset_98.should_receive(:thumbnails_count).and_return("1")
    asset_99 = mock_model(Asset)
    asset_99.should_receive(:content_type).and_return("MyString")
    asset_99.should_receive(:filename).and_return("MyString")
    asset_99.should_receive(:size).and_return("1")
    asset_99.should_receive(:parent_id).and_return("1")
    asset_99.should_receive(:thumbnail).and_return("MyString")
    asset_99.should_receive(:width).and_return("1")
    asset_99.should_receive(:height).and_return("1")
    asset_99.should_receive(:site_id).and_return("1")
    asset_99.should_receive(:thumbnails_count).and_return("1")

    assigns[:assets] = [asset_98, asset_99]
  end

  it "should render list of admin_assets" do
    render "/admin/assets/index.html.haml"
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "MyString", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

