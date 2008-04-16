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
    
    response.should have_tag("form[action=#{admin_asset_path(@asset)}][method=post]") do
      with_tag('input#asset_content_type[name=?]', "asset[content_type]")
      with_tag('input#asset_filename[name=?]', "asset[filename]")
      with_tag('input#asset_size[name=?]', "asset[size]")
      with_tag('input#asset_thumbnail[name=?]', "asset[thumbnail]")
      with_tag('input#asset_width[name=?]', "asset[width]")
      with_tag('input#asset_height[name=?]', "asset[height]")
      with_tag('input#asset_thumbnails_count[name=?]', "asset[thumbnails_count]")
    end
  end
end


