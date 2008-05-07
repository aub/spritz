require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/index.html.haml" do
  include Admin::AssetsHelper

  define_models :index do
    model Asset do
      stub :one, :site => all_stubs(:site), :filename => 'fake'
    end
  end
  
  before(:each) do
    assigns[:assets] = Asset.paginate :page => 1, :per_page => 18
  end

  it "should render list of admin_assets" do
    render "/admin/assets/index.html.haml"
    response.should have_tag("a[href=?]", edit_admin_asset_path(assets(:one)))
  end
end

