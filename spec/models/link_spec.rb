require File.dirname(__FILE__) + '/../spec_helper'

describe Link do

  define_models :link do
    model Link do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    before(:each) do
      @link = Link.new
    end

    it "should require a url" do
      @link.should_not be_valid
      @link.should have(2).errors_on(:url)
    end
    
    it "should require the url to be a reasonable size" do
      @link.url = 'ab'
      @link.should have(1).errors_on(:url)      
    end
    
    it "should requre a title" do
      @link.should have(1).error_on(:title)
    end
    
    it "should be valid" do
      @link.url = 'hack'
      @link.should be_valid
    end
  end
  
  it "should be convertible to liquid" do
    links(:one).to_liquid.should be_a_kind_of(BaseDrop)
  end
  
  it "should belong to a site" do
    links(:one).site.should == sites(:default)
  end
  
  describe "appending http:// to the url" do
    define_models :link
    
    it "should force-add http:// to the beginning of the link when saving." do
      links(:one).update_attribute(:url, 'www.abc.com')
      links(:one).reload.url.should == 'http://www.abc.com'
    end
    
    it "should not double-add http" do
      links(:one).update_attribute(:url, 'http://www.abc.com')
      links(:one).reload.url.should == 'http://www.abc.com'
    end
    
    it "should not add http to empty strings" do
      links(:one).update_attribute(:url, '')
      links(:one).reload.url.should == ''
    end
  end  
end
