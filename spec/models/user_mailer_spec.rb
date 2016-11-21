require File.dirname(__FILE__) + '/../spec_helper'

describe UserMailer do
  define_models :user_mailer
  
  describe "forgot_password" do
    define_models :user_mailer
    
    before(:each) do
      UserMailer.default_url_options[:host] = 'http://FAKE.COM'
      @response = UserMailer.deliver_forgot_password(users(:nonadmin))
    end
    
    it "should send an email to the user" do
      @response.to[0].should == users(:nonadmin).email
    end
    
    it "should put the correct url in the mail" do
      @response.body.should match(/admin\/users\/#{users(:nonadmin).remember_token}\/login_from_token/)
    end
  end
end
