require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  define_models :site do
    model Site do
      stub :other, :subdomain => 'hold', :domain => 'none'
    end
  end
  
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

  describe "relationship to links" do
    define_models :site do
      model Link do
        stub :google, :site => all_stubs(:site)
        stub :yahoo, :site => all_stubs(:site)
      end
    end
    
    it "should have a collection of links" do
      sites(:default).links.sort_by(&:id).should == Link.find_all_by_site_id(sites(:default).id).sort_by(&:id)
    end
    
    it "should destroy the links when destroyed" do
      lambda { sites(:default).destroy }.should change(Link, :count).by(-2)
    end
  end

  describe "relationship to portfolios" do
    define_models :site do
      model Portfolio do
        stub :uno, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 4
        stub :due, :site => all_stubs(:site), :parent_id => nil
        stub :tre, :site => all_stubs(:site), :parent_id => all_stubs(:uno_portfolio).object_id, :lft => 2, :rgt => 3
        stub :quatro, :site => all_stubs(:other_site), :parent_id => nil, :lft => 1, :rgt => 2
      end
    end
    
    it "should have a collection of portfolios" do
      sites(:default).portfolios.sort_by(&:id).should == [portfolios(:uno), portfolios(:due), portfolios(:tre)].sort_by(&:id)
    end
    
    it "should include portfolios that are not at the top level" do
      sites(:default).portfolios.include?(portfolios(:tre)).should be_true
    end
    
    it "should destroy the portfolios recursively when destroyed" do
      lambda { sites(:default).destroy }.should change(Portfolio, :count).by(-3)
    end

    it "should provide a method for only accessing the top-level portfolios" do
      sites(:default).portfolios.find_roots.sort_by(&:id).should == [portfolios(:uno), portfolios(:due)].sort_by(&:id)
    end
    
    describe "creation of child portfolios with a parent" do
      define_models :site    

      before(:each) do
        @params = { :title => 'drawings' }
      end

      it "should create a root-level portfolio if no parent is given" do
        portfolio = sites(:default).portfolios.create_with_parent_id(@params, nil)
        portfolio.should_not be_nil
        portfolio.parent.should be_nil
      end

      it "should append the child to the parent if it is given" do
        portfolio = sites(:default).portfolios.create_with_parent_id(@params, portfolios(:uno).id)
        portfolio.should_not be_nil
        portfolio.parent.should == portfolios(:uno)
      end
      
      it "should not append the child if the requested parent is in a different site" do
        portfolio = sites(:default).portfolios.create_with_parent_id(@params, portfolios(:quatro).id)
        portfolio.should_not be_nil
        portfolio.parent.should be_nil
      end
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
      Site.setting(:testy, :integer, 2)
      sites(:default).testy.should == 2
    end
    
    it "should have a default value for the settings (empty hash)" do
      Site.new.settings.should == {}
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
      Site.new.theme.should == 'default'
      sites(:default).theme = 'booya'
      sites(:default).reload.theme.should == 'booya'
    end
    
    it "should have a setting for the title" do
      Site.new.title.should == ''
      sites(:default).title = 'booya'
      sites(:default).reload.title.should == 'booya'
    end
  end
    
  describe "theme management" do
    define_models :site
    
    it "should provide a method for accessing the theme" do
      sites(:default).theme = 'booya'
      sites(:default).current_theme.should eql(Theme.find('booya'))
    end
  end
  
  describe "liquid conversion" do
    define_models :site
    
    it "should be convertible to liquid" do
      sites(:default).to_liquid.should be_a_kind_of(BaseDrop)
    end
  end
  
  describe "action cache directory" do
    define_models :site
    
    it "should be the site's subdomain" do
      sites(:default).action_cache_root.should == sites(:default).subdomain
    end
  end
  
  describe "relationship to caches" do
    define_models :site do
      model CacheItem do
        stub :one, :site => all_stubs(:site), :path => 'a/b/c'
        stub :two, :site => all_stubs(:site), :path => 'a/b/c/d'
      end
    end
    
    it "should contain caches" do
      sites(:default).cache_items.sort_by(&:id).should == [cache_items(:one), cache_items(:two)].sort_by(&:id)
    end
    
    it "should destroy them when destroyed" do
      lambda { sites(:default).destroy }.should change(CacheItem, :count).by(-2)
    end
  end
    
  describe "relationship to assets" do
    define_models :site do
      model Asset do
        stub :one, :site => all_stubs(:site), :thumbnail => nil, :parent_id => nil, :filename => 'back', :thumbnails_count => 1
        stub :two, :site => all_stubs(:site), :thumbnail => nil, :parent_id => nil, :filename => 'wack'
        stub :tre, :site => all_stubs(:site), :thumbnail => 'display', :parent_id => all_stubs(:one_asset).object_id, :filename => 'smack'
      end
    end
    
    it "should have a collection of assets" do
      sites(:default).assets.sort_by(&:id).should == [assets(:one), assets(:two)].sort_by(&:id)
    end
    
    it "should not include assets that are thumbnails" do
      sites(:default).assets.include?(assets(:tre)).should be_false
    end
    
    it "should destroy its assets when keeling over" do
      lambda { sites(:default).destroy }.should change(Asset, :count).by(-2)
    end
  end  
end
