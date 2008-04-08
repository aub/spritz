require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  before(:each) do
    @site = Site.new
  end

  it "should be valid" do
    @site.should be_valid
  end

  describe "accessing the site for a domain and subdomain" do
    define_models :site
    
    it "should return the correct site for a given domain" do
      Site.for(sites(:default).domain, []).should == sites(:default)
    end
    
    it "should return the correct site for a given subdomain" do
      Site.for('blah', [sites(:default).subdomain]).should == sites(:default)
    end
    
    it "should return nil for no match" do
      Site.for('blah', []).should be_nil
    end
  end
  
  describe "relationship to memberships" do
    define_models :site
    
    it "should have a collection of memberships" do
      sites(:default).memberships.sort_by(&:id).should == Membership.find_all_by_site_id(sites(:default).id).sort_by(&:id)
    end
    
    it "should destroy the memberships when destroyed" do
      lambda { sites(:default).destroy }.should change(Membership, :count).by(-3)
    end
    
    it "should have many members" do
      sites(:default).members.sort_by(&:id).should == Membership.find_all_by_site_id(sites(:default).id).collect(&:user).uniq.sort_by(&:id)
    end
  end
  
  describe "relationship to users" do
    define_models :site
    
    it "should return a list of users" do
      sites(:default).users.should == User.find_all_by_site(sites(:default))
    end
    
    it "should return a user by id" do
      sites(:default).user(users(:nonadmin).id).should == users(:nonadmin)
    end
    
    it "should find a user by remember token" do
      sites(:default).user_by_remember_token(users(:nonadmin).remember_token).should == users(:nonadmin)
    end
  end
  
  describe "settings management" do
    define_models :site
    
    it "should be a settings manager" do
      Site.setting(:test, :integer, 2)
      sites(:default).test.should == 2
    end
    
    it "should have a default value for the settings (empty hash)" do
      sites(:default).settings.should == {}
    end
    
    it "should save and reload the settings" do
      Site.setting(:test, :integer, 2)
      sites(:default).test = 12
      sites(:default).reload.test.should == 12      
    end
  end
  
  describe "applied settings" do
    define_models :site
    
    it "should have a setting for the theme" do
      sites(:default).theme.should == 'default'
      sites(:default).theme = 'booya'
      sites(:default).reload.theme.should == 'booya'
    end
  end
  
  describe "theme management" do
    define_models :site
    
    it "should provide a method for accessing the theme" do
      sites(:default).theme = 'booya'
      sites(:default).current_theme.should eql(Theme.find('booya'))
    end
  end
end
