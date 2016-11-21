require File.dirname(__FILE__) + '/../spec_helper'

describe GalleryDrop do
  define_models :gallery_drop do
    model Gallery do
      stub :one, :site => all_stubs(:site), :name => 'n', :address => 'a', :city => 'c', :state => 's', :zip => 'z', :country => 'c', :phone => 'p', :email => 'e', :url => 'u', :description_html => 'dh'
    end
  end
  
  before(:each) do
    @drop = GalleryDrop.new(galleries(:one))
  end
    
  it "should provide access to the various simple attributes" do
    [ :name, :address, :city, :state, :zip, :country, :phone, :email, :url ].each do |attribute|
      @drop.before_method(attribute.to_s).should == galleries(:one).send(attribute)
    end
  end
  
  it "should provide access to the description by returning the description_html" do
    @drop.description.should == galleries(:one).description_html
  end
end
