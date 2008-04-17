require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/index.html.haml" do
  include Admin::AssetsHelper
  
  before(:each) do
    @asset_98 = mock_model(Asset)
    @asset_98.should_receive(:public_filename).and_return("MyString")
    @asset_99 = mock_model(Asset)
    @asset_99.should_receive(:public_filename).and_return("MyString")

    assigns[:assets] = [@asset_98, @asset_99]
  end

  it "should render list of admin_assets" do
    render "/admin/assets/index.html.haml"
    response.should have_tag("a[href=?]", edit_admin_asset_path(@asset_98))
    response.should have_tag("a[href=?]", edit_admin_asset_path(@asset_99))
  end
end

