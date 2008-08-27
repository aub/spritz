require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/new.html.haml" do
  include Admin::AssetsHelper
  
  before(:each) do
    @asset = mock_model(Asset)
    @asset.stub!(:new_record?).and_return(true)
    @asset.stub!(:content_type).and_return("MyString")
    @asset.stub!(:filename).and_return("MyString")
    @asset.stub!(:size).and_return("1")
    @asset.stub!(:parent_id).and_return("1")
    @asset.stub!(:thumbnail).and_return("MyString")
    @asset.stub!(:width).and_return("1")
    @asset.stub!(:height).and_return("1")
    @asset.stub!(:site_id).and_return("1")
    @asset.stub!(:thumbnails_count).and_return("1")
    assigns[:asset] = @asset
  end

  it "should render new form" do
    render "/admin/assets/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", admin_assets_path) do
      with_tag("input#asset_attachment[type=file][name=?]", "asset[attachment]")
    end
  end
end


