require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  define_models :site do
    model Asset do
      stub :one, :site => all_stubs(:site), :thumbnail => nil, :parent_id => nil, :filename => 'back', :thumbnails_count => 1
      stub :two, :site => all_stubs(:site), :thumbnail => nil, :parent_id => nil, :filename => 'wack'
      stub :tre, :site => all_stubs(:site), :thumbnail => 'display', :parent => all_stubs(:one_asset), :filename => 'smack'
    end
  end

  describe "validations" do
    before(:each) do
      @site = Site.new
    end
    
    after(:each) do
      Spritz.multi_sites_enabled = false
    end

    it "should require a title" do
      @site.should_not be_valid
      @site.should have(1).error_on(:title)
    end

    it "should require a subdomain" do
      Spritz.multi_sites_enabled = true
      @site.should have(1).error_on(:subdomain)
    end
    
    it "should limit the number of home news items" do
      @site.home_news_item_count = 11
      @site.should_not be_valid
      @site.should have(1).error_on(:home_news_item_count)
    end

    it "should allow multiple empty domains" do
      site1 = Site.create(:title => 't', :subdomain => 's')
      site1.should be_valid
      
      site2 = Site.create(:title => 't', :subdomain => 's2')
      site2.should be_valid
    end
    
    it "should allow empty subdomains if multi-site is disabled" do
      Spritz.multi_sites_enabled = false
      site = Site.create(:title => 't')
      site.should have(0).errors_on(:subdomain)
    end

    it "should be valid" do
      @site.title = 'test title'
      @site.subdomain = 'ack'
      @site.theme_path = 'default'
      @site.should be_valid
    end
  end

  describe "accessing the site for a domain" do
    define_models :site
    
    describe "with multi_site enabled" do
      define_models :site
      
      before(:all) do
        Spritz.multi_sites_enabled = true
      end
      
      after(:all) do
        Spritz.multi_sites_enabled = false
      end

      it "should return the correct site for a given domain" do
        Site.for(sites(:default).domain, nil).should == sites(:default)
      end

      it "should return the correct site for a given subdomain" do
        Site.for(nil, [sites(:default).subdomain]).should == sites(:default)
      end

      it "should return nil for no match" do
        Site.for('blah', nil).should be_nil
      end      
    end
    
    describe "with multi_sites disabled" do
      define_models :site
      
      before(:all) do
        Spritz.multi_sites_enabled = false
      end
      
      after(:all) do
        Spritz.multi_sites_enabled = true
      end
      
      it "should return the first site always" do
        Site.for('acid', nil).should == Site.find(:first)
      end
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
        stub :google, :site => all_stubs(:site), :position => 2
        stub :yahoo, :site => all_stubs(:site), :position => 1
        stub :boston, :site => all_stubs(:site), :position => 3
      end
    end
    
    it "should have a collection of links" do
      sites(:default).links.sort_by(&:id).should == Link.find_all_by_site_id(sites(:default).id).sort_by(&:id)
    end

    it "should order the links by position" do
      sites(:default).links.should == [links(:yahoo), links(:google), links(:boston)]
    end
    
    it "should destroy the links when destroyed" do
      lambda { sites(:default).destroy }.should change(Link, :count).by(-3)
    end
    
    it "should allow reordering of the links" do
      sites(:default).links.reorder!([links(:boston).id, links(:yahoo).id, links(:google).id])
      sites(:default).links.should == [links(:boston), links(:yahoo), links(:google)]
    end
  end

  describe "relationship to news items" do
    define_models :site do
      model NewsItem do
        stub :uno, :site => all_stubs(:site), :position => 3
        stub :due, :site => all_stubs(:site), :position => 1
        stub :tre, :site => all_stubs(:site), :position => 2
      end
    end
    
    it "should have a collection of news items" do
      sites(:default).news_items.sort_by(&:id).should == [news_items(:uno), news_items(:due), news_items(:tre)].sort_by(&:id)
    end

    it "should order the news items by position" do
      sites(:default).news_items.should == [news_items(:due), news_items(:tre), news_items(:uno)]
    end

    it "should allow reordering of the news items" do
      sites(:default).news_items.reorder!([news_items(:uno).id, news_items(:due).id, news_items(:tre).id])
      sites(:default).news_items.should == [news_items(:uno), news_items(:due), news_items(:tre)]
    end
    
    it "should destroy the news items when destroyed" do
      lambda { sites(:default).destroy }.should change(NewsItem, :count).by(-3)
    end
  end

  describe "relationship to portfolios" do
    define_models :site do
      model Portfolio do
        stub :uno, :site => all_stubs(:site), :parent_id => nil, :lft => 1, :rgt => 2, :position => 2
        stub :due, :site => all_stubs(:site), :parent_id => nil, :lft => 3, :rgt => 4, :position => 1
        stub :tre, :site => all_stubs(:site), :parent_id => nil, :lft => 5, :rgt => 6, :position => 3
        stub :quatro, :site => all_stubs(:other_site), :parent_id => nil, :lft => 7, :rgt => 8, :position => 1
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
    
    it "should order the top-level portfolios by position" do
      sites(:default).root_portfolios.should == [portfolios(:due), portfolios(:uno)]
    end
    
    it "should allow reordering of the top-level portfolios" do
      sites(:default).root_portfolios.reorder!([portfolios(:uno).id, portfolios(:due).id])
      sites(:default).root_portfolios.reload.should == [portfolios(:uno), portfolios(:due)]
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
    
    it "should find a user by email" do
      sites(:default).user_by_email(users(:nonadmin).email).should == users(:nonadmin)
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
      Site.create({ :title => 'junk', :subdomain => 'ack' }).theme_path.should == 'dark'
    end
    
    it "should copy the themes into the appropriate directory on create" do
      Theme.should_receive(:create_defaults_for).and_return(true)
      Site.create({ :title => 'junk', :subdomain => 'ack' })
    end
    
    it "should set the theme path to a default on create" do
      Theme.stub!(:create_defaults_for).and_return(true)
      s = Site.create({ :title => 'junk', :subdomain => 'ack' })
      s.reload.theme_path.should == 'dark'
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
  
  describe "page cache directory" do
    define_models :site

    after(:each) do
      Spritz.multi_sites_enabled = false
    end

    it "should point to a general directory without multi_site enabled" do
      Spritz.multi_sites_enabled = false
      sites(:default).page_cache_path.should == Pathname.new(RAILS_ROOT) + 'tmp/cache'
    end
    
    it "should be a specific directory for the site's subdomain with multi_site enabled" do
      Spritz.multi_sites_enabled = true
      sites(:default).page_cache_path.should == Pathname.new(RAILS_ROOT) + 'tmp/cache' + sites(:default).subdomain
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
    define_models :site
    
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
  
  describe "relationship to resume sections" do
    define_models :site do
      model ResumeSection do
        stub :one, :site => all_stubs(:site), :position => 3
        stub :two, :site => all_stubs(:site), :position => 1
        stub :tre, :site => all_stubs(:site), :position => 2
      end
    end
    
    it "should have a collection of resume sections" do
      sites(:default).resume_sections.sort_by(&:id).should == [resume_sections(:one), resume_sections(:two), resume_sections(:tre)].sort_by(&:id)
    end
    
    it "should destroy its resume sections when keeling over" do
      lambda { sites(:default).destroy }.should change(ResumeSection, :count).by(-3)
    end
    
    it "should order them by position" do
      sites(:default).resume_sections.should == [resume_sections(:one), resume_sections(:two), resume_sections(:tre)].sort_by(&:position)
    end
    
    it "should allow reordering of the resume sections" do
      sites(:default).resume_sections.reorder!([resume_sections(:one).id, resume_sections(:two).id, resume_sections(:tre).id])
      sites(:default).resume_sections.should == [resume_sections(:one), resume_sections(:two), resume_sections(:tre)]
    end
  end

  describe "relationship to galleries" do
    define_models :site do
      model Gallery do
        stub :one, :site => all_stubs(:site), :position => 3
        stub :two, :site => all_stubs(:site), :position => 1
        stub :tre, :site => all_stubs(:site), :position => 2
      end
    end
    
    it "should have a collection of galleries" do
      sites(:default).galleries.sort_by(&:id).should == [galleries(:one), galleries(:two), galleries(:tre)].sort_by(&:id)
    end
    
    it "should destroy its galleries when keeling over" do
      lambda { sites(:default).destroy }.should change(Gallery, :count).by(-3)
    end
    
    it "should order them by position" do
      sites(:default).galleries.should == [galleries(:one), galleries(:two), galleries(:tre)].sort_by(&:position)
    end
    
    it "should allow reordering of the galleries" do
      sites(:default).galleries.reorder!([galleries(:one).id, galleries(:two).id, galleries(:tre).id])
      sites(:default).galleries.should == [galleries(:one), galleries(:two), galleries(:tre)]
    end
  end

  
  describe "home image" do
    define_models :site do
      model AssignedAsset do
        stub :one, :asset => all_stubs(:one_asset), :asset_holder => all_stubs(:site), :asset_holder_type => 'Site'
      end
    end
    
    it "should have an assigned home image" do
      sites(:default).assigned_home_image.should == assigned_assets(:one)
    end
    
    it "should destroy the assigned home image when being destroyed" do
      lambda { sites(:default).destroy }.should change(AssignedAsset, :count).by(-1)
    end
    
    it "should destroy the assigned home image when we give it another one" do
      new_aa = AssignedAsset.new({:asset_id => assets(:two).id})
      sites(:default).assigned_home_image = new_aa
      one_id = assigned_assets(:one).id
      AssignedAsset.find_by_id(one_id).should be_nil
    end
    
    it "should have a home image through the assignment" do
      sites(:default).home_image.should == assets(:one)
    end
  end
  
  it "should convert its home_text column to html on save" do
    sites(:default).update_attribute(:home_text, 'abc')
    sites(:default).reload.home_text_html.should == '<p>abc</p>'
  end
end
