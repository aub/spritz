require File.dirname(__FILE__) + '/../spec_helper'

describe AssetDrop do
  define_models :portfolio_item_drop do
    model Asset do
      stub :one, :site => all_stubs(:site), 
        :attachment_file_name => 'f.png', :attachment_content_type => 'c', :attachment_file_size => 1, :attachment_updated_at => Time.now,
        :fields => { :title => 'way cool', :dimensions => '1x2', :price => '' }
    end
    model Portfolio do
      stub :one, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
    end
    model AssignedAsset do
      stub :one, :asset => all_stubs(:one_asset), :portfolio => all_stubs(:one_portfolio)
    end
  end
    
  before(:each) do
    @drop = AssetDrop.new(assets(:one), portfolios(:one))
  end

  it "should provide access to the attachment's urls" do
    @drop.should have_attached_image(:attachment, '')
  end
  
  it "should provide access to a url" do
    @drop.url.should == "/portfolios/#{portfolios(:one).to_param}/items/#{assigned_assets(:one).to_param}"
  end
  
  it "should provide access to the portfolio" do
    @drop.portfolio.should == portfolios(:one)
  end
  
  it "should give the list of fields for the asset" do
    @drop.fields.should == [{"name"=>"title", "value"=>"way cool"}, {"name"=>"dimensions", "value"=>"1x2"}]
  end
  
  it "should not include the fields that are nil" do
    @drop.fields.find { |fld| fld['name'] == 'description' }.should be_nil
  end
  
  it "should not include the fields that are empty" do
    @drop.fields.find { |fld| fld['name'] == 'price' }.should be_nil
  end
end
