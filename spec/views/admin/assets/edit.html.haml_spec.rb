require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/assets/edit.html.haml" do
  include Admin::AssetsHelper
  
  before do
    @asset = mock_model(Asset)
    @asset.stub!(:title).and_return("MyString")
    @asset.stub!(:medium).and_return("MyString")
    @asset.stub!(:dimensions).and_return("1")
    @asset.stub!(:price).and_return("1")
    @asset.stub!(:date).and_return("MyString")
    @asset.stub!(:description).and_return("1")
    @asset.stub!(:public_filename).and_return("1")
    assigns[:asset] = @asset
  end

  it "should render edit form" do
    render "/admin/assets/edit.html.haml"
  end
end


