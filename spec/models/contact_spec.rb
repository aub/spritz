require File.dirname(__FILE__) + '/../spec_helper'

describe Contact do
  define_models :contact do
    model Contact do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  describe "validations" do
    before(:each) do
      @contact = Contact.new
    end

    it "should be valid" do
      @contact.should be_valid
    end
  end
  
  describe "relationship to the site" do
    define_models :contact
    
    it "should balong to a site" do
      contacts(:one).site.should == sites(:default)
    end
  end
end
