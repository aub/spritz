require File.dirname(__FILE__) + '/../spec_helper'

describe Gallery do
  
  define_models :gallery do
    model Gallery do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  before(:each) do
    @gallery = Gallery.new
  end
  
  describe 'validations' do
    define_models :gallery
    
    it "should require a name" do
      @gallery.should_not be_valid
      @gallery.should have(1).error_on(:name)
    end
    
    it "should be valid" do
      @gallery.name = 'shazam'
      @gallery.should be_valid
    end
  end
  
  it "should be convertible to liquid" do
    galleries(:one).to_liquid.should be_a_kind_of(BaseDrop)
  end
  
  it "should convert its description column to html on save" do
    galleries(:one).update_attribute(:description, 'abc')
    galleries(:one).reload.description_html.should == '<p>abc</p>'
  end
  
  it "should belong to a site" do
    galleries(:one).site.should == sites(:default)
  end
  
end
