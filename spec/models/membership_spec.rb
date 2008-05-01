require File.dirname(__FILE__) + '/../spec_helper'

describe Membership do
  
  describe "validations" do
    it "should require a site_id" do
      m = Membership.new
      m.should_not be_valid
      m.should have(1).error_on(:site_id)
    end
    
    it "should require a user id" do
      m = Membership.new
      m.should_not be_valid
      m.should have(1).error_on(:user_id)      
    end
    
    it "should be valid" do
      m = Membership.new(:user_id => 1, :site_id => 1)
      m.should be_valid
    end
  end
  
  define_models :membership do
    model User do
      stub :deleted, :login => 'deleted', :email => 'deleted@example.com', :remember_token => 'deletedtoken', :admin => false,
        :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
        :state => 'deleted', :created_at => Time.now.utc - 3.days, :activated_at => 3.months.ago.utc, 
        :remember_token_expires_at => 2.weeks.from_now.utc
    end
    
    model Membership do
      stub :deleted_on_default, :site => all_stubs(:site),         :user => all_stubs(:deleted_user)
    end
  end
  
  describe "relationship to users" do
    define_models :membership
    
    it "should belong to a user" do
      memberships(:admin_on_default).user.should == users(:admin)
    end
  end
  
  describe "relationship to sites" do
    define_models :membership
    
    it "should belong to a site" do
      memberships(:admin_on_default).site.should == sites(:default)
    end
  end
  
  # it "finds site members" do
  #   sites(:default).members.sort_by { |u| u.login }.should == [users(:deleted), users(:admin), users(:nonadmin)]
  #   User.find_all_by_site(sites(:default)).sort_by { |u| u.login }.should == [users(:deleted), users(:admin), users(:nonadmin)]
  # end
  # 
  # it "finds site admins" do
  #   sites(:default).admins.should == [users(:admin)]
  # end
  # 
  # it "finds all users" do
  #   sites(:default).users.sort_by { |u| u.login }.should == [users(:deleted), users(:admin), users(:nonadmin)]
  #   User.find_all_by_site(sites(:default)).sort_by { |u| u.login }.should == [users(:deleted), users(:admin), users(:nonadmin)]
  # end
end