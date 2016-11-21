require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UsersHelper do
  define_models :users_helper
  
  describe "membership_data helper" do
    define_models :users_helper do
      model User do
        stub :joe, :login => 'joe', :admin => false, :state => 'active'
      end

      model Membership do
        stub :joe_on_default, :site => all_stubs(:site), :user => all_stubs(:joe_user)
        stub :joe_on_other, :site => all_stubs(:other_site), :user => all_stubs(:joe_user)
      end
    end
      
    it "should have a method for the user membership options" do
      helper.membership_data(users(:joe)).should_not be_nil
    end
  
    it "should indicate a lack of memberships if there are none" do
      Membership.find(:all).each(&:destroy)
      helper.membership_data(users(:joe)).should match(/No memberships./)
    end
    
    it "should indicate a list of memberships if there are some" do
      helper.membership_data(users(:joe)).should match(/Member of:/)
    end
    
    it "should inlude links to the sites the user is a member of" do
      helper.membership_data(users(:joe)).should match(/#{users(:joe).sites.inject([]) { |l,s| l << s.title } * ', '}/) 
    end
    
    it "should include a link for managing memberships" do
      helper.membership_data(users(:joe)).should have_tag('a[href=?]', admin_user_memberships_path(users(:joe)))
    end
    
    it "should include a link for managing memberships even if there are no memberships currently" do
      Membership.find(:all).each(&:destroy)
      helper.membership_data(users(:joe)).should have_tag('a[href=?]', admin_user_memberships_path(users(:joe)))
    end
  end  
end
