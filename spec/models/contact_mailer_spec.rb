require File.dirname(__FILE__) + '/../spec_helper'

describe ContactMailer do
  define_models :contact_mailer
  
  describe "new contact" do
    define_models :contact_mailer
    
    before(:each) do
      @contact_properties = { :name => 'n', :email => 'e', :phone => 'p', :message => 'm' }
      @contact = mock_model(Contact, @contact_properties.dup)
      
      @response = ContactMailer.deliver_new_contact(users(:nonadmin), @contact)
    end
    
    it "should send an email to the user" do
      @response.to[0].should == users(:nonadmin).email
    end
    
    it "should put the contact parameters into the mail" do
      @contact_properties.each do |k, v|
        @response.body.to_s.should match(/#{k.to_s.capitalize}:(\s+)#{v}/)
      end
    end
  end
end
