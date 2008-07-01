require File.dirname(__FILE__) + '/../spec_helper'

describe ContactMailer do
  define_models :contact_mailer
  
  describe "new contact" do
    define_models :contact_mailer
    
    before(:each) do
      @contact_properties = { :name => 'n', :email => 'e', :phone => 'p', :message => 'm' }
      @contact = mock_model(Contact, @contact_properties)
      
      @response = ContactMailer.deliver_new_contact(users(:nonadmin), @contact)
    end
    
    it "should send an email to the user" do
      @response.to[0].should == users(:nonadmin).email
    end
    
    it "should put the contact parameters into the mail" do
      @contact_properties.each do |key, value|
        @response.body.should match(/#{key.to_s.capitalize}:(\s+)#{value}/)
      end
    end
  end
end
