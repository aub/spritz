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

    it "should require a name" do
      @contact.should_not be_valid
      @contact.should have(1).error_on(:name)
    end

    it "should require an email" do
      @contact.should_not be_valid
      @contact.should have(1).error_on(:email)
    end

    it "should require a reasonable format for the email" do
      @contact.email = 'steve@'
      @contact.should have(1).error_on(:email)
    end

    it "should be valid" do
      @contact.name = 'Freddy Kruger'
      @contact.email = 'freddy@crazyguy.com'
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
