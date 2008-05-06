require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  define_models :site

  describe "validations" do
    before(:each) do
      @site = Site.new
    end

    it "should require a title" do
      @site.should_not be_valid
      @site.should have(1).error_on(:title)
    end

    it "should limit the number of home news items" do
      @site.home_news_item_count = 11
      @site.should_not be_valid
      @site.should have(1).error_on(:home_news_item_count)
    end

    it "should be valid" do
      @site.title = 'test title'
      @site.theme_path = 'default'
      @site.should be_valid
    end
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

  describe "relationship to news items" do
    define_models :site do
      model NewsItem do
        stub :show, :site => all_stubs(:site)
        stub :publication, :site => all_stubs(:site)
      end
    end
    
    it "should have a collection of news items" do
      sites(:default).news_items.sort_by(&:id).should == [news_items(:show), news_items(:publication)].sort_by(&:id)
    end
    
    it "should destroy the news items when destroyed" do
      lambda { sites(:default).destroy }.should change(NewsItem, :count).by(-2)
    end
  end

  describe "relationship to portfolios" do
    define_models :site do
      model Portfolio do
        stub :uno, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2
        stub :due, :site => all_stubs(:site), :parent_id => nil, :lft => 3, :rgt => 4
        stub :tre, :site => all_stubs(:site), :parent_id => nil, :lft => 5, :rgt => 6
        stub :quatro, :site => all_stubs(:other_site), :parent_id => nil, :lft => 7, :rgt => 8
      end
    end
    
    before(:each) do
      portfolios(:tre).move_to_child_of(portfolios(:uno))
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
      sites(:default).root_portfolios.sort_by(&:id).should == [portfolios(:uno), portfolios(:due)].sort_by(&:id)
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
  
  describe "theme management" do
    define_models :site

    before(:each) do
      @theme1 = Theme.new('1', sites(:default))
      @theme2 = Theme.new('2', sites(:default))
      Theme.stub!(:find_all_for).and_return([@theme1, @theme2])
    end
    
    it "should provide a method for accessing the theme" do
      sites(:default).theme_path = '2'
      sites(:default).theme.should eql(@theme2)
    end
    
    it "should setup a default theme on create" do
      Site.create.theme_path.should == 'dark'
    end
    
    it "should copy the themes into the appropriate directory on create" do
      Theme.should_receive(:create_defaults_for).and_return(true)
      Site.create
    end
    
    it "should provide a list of themes available to the site" do
      sites(:default).themes.should == [@theme1, @theme2]
    end
    
    it "should have a method for finding a theme by name" do
      sites(:default).find_theme('1').should == @theme1
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
        stub :tre, :site => all_stubs(:site), :thumbnail => 'display', :parent_id => nil, :filename => 'smack'
      end
    end
    
    before(:each) do
      assets(:tre).update_attribute(:parent_id, assets(:one).id)
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
  
  describe "relationship to contacts" do
    define_models :site do
      model Contact do
        stub :one, :site => all_stubs(:site)
        stub :two, :site => all_stubs(:site)
      end
    end
    
    it "should have a collection of contacts" do
      sites(:default).contacts.sort_by(&:id).should == [contacts(:one), contacts(:two)].sort_by(&:id)
    end
    
    it "should destroy its contacts when keeling over" do
      lambda { sites(:default).destroy }.should change(Contact, :count).by(-2)
    end
  end
end
