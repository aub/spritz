require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/edit.html.haml" do
  include Admin::AssetsHelper
  
  before do
    @asset = mock_model(Asset)
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

  it "should render edit form" do
    render "/admin/assets/edit.html.haml"
  end
end


