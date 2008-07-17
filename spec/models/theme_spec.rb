require File.dirname(__FILE__) + '/../spec_helper'

describe Theme do
  define_models :theme

  before(:each) do
    cleanup_theme_directory
  end
  
  after(:each) do
    cleanup_theme_directory
  end

  it "should have a theme root" do
    Theme.theme_root.should == File.join(RAILS_ROOT, THEME_PATH_ROOT)
  end
  
  it "should have a theme defaults directory" do
    Theme.defaults_directory.should == File.join(RAILS_ROOT, THEME_PATH_ROOT, 'default')
  end
  
  it "should provide a useful equality operator" do
    Theme.new('a', sites(:default)).should eql(Theme.new('a', sites(:default)))
  end

  it "should give the location of its preview image" do
    Theme.new('a', sites(:default)).preview.should == File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'a', 'preview.png')
  end
  
  describe "reading the about.yml file" do
    define_models :theme

    before(:each) do
      Theme.create_defaults_for(sites(:default))
    end
    
    it "should give access to the list of properties" do
      YAML.should_receive(:load_file).and_return({ :a => 'a', :c => 'c' })
      Theme.new('light', sites(:default)).properties.should == { :a => 'a', :c => 'c' }
    end
    
    it "should get empty properties if the file doesn't exist" do
      Theme.new('hack', sites(:default)).properties.should == {}
    end
    
    it "should create methods to access the about fields" do
      theme = Theme.new('light', sites(:default))
      [:title, :version, :author, :author_email, :author_site, :summary].each do |attribute|
        theme.send(attribute).should == theme.properties[attribute.to_s]
      end
    end
    
    it "should return nil for the value if the file doesn't exist" do
      Theme.new('hack', sites(:default)).title.should == nil
    end
  end
  
  describe "create_defaults_for method" do
    define_models :theme
    
    it "should create a directory for the site's themes" do
      Theme.create_defaults_for(sites(:default))
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}")).should be_true
    end
    
    it "should copy the default themes into the site's directory" do
      Theme.create_defaults_for(sites(:default))
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'dark')).should be_true
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'light')).should be_true
    end
    
    it "should not recopy the defaults directory into an existing directory" do
      Theme.create_defaults_for(sites(:default))
      Theme.create_defaults_for(sites(:default))
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'default')).should be_false
    end
  end
  
  describe "find_all_for method" do
    define_models :theme
    
    it "should create a list of themes for the given site" do
      Theme.create_defaults_for(sites(:default))
      Theme.find_all_for(sites(:default)).should eql([Theme.new('dark', sites(:default)), Theme.new('light', sites(:default))])
    end
  end
  
  describe "active? method" do
    define_models :theme

    before(:each) do
      Theme.create_defaults_for(sites(:default))
      sites(:default).update_attribute(:theme_path, 'dark')
    end
    
    it "should return true if it is the theme selected by its site" do
      sites(:default).find_theme('dark').should be_active
    end
    
    it "should return false for unselected themes" do
      sites(:default).find_theme('light').should_not be_active
    end
  end
  
  describe "accessing resources" do
    define_models :theme

    before(:each) do
      Theme.create_defaults_for(sites(:default))
      sites(:default).update_attribute(:theme_path, 'dark')
    end
    
    it "should return a list of all available resources" do
      sites(:default).theme.resources.size.should == 10
    end
    
    it "should find a given resource by name" do
      sites(:default).theme.resource('home-liquid').name.should == 'home-liquid'
    end
  end
  
  describe "uploading themes" do
    define_models :theme
    
    before(:each) do
      @zip_file = fixture_file_upload(File.join(%w(themes darker.zip)), 'application/zip')
      Theme.create_from_zip_data(@zip_file, sites(:default))
      @base_dir = Theme.site_theme_dir(sites(:default))
    end
    
    it "should create the theme file when it works correctly" do
      File.exists?(File.join(@base_dir, 'darker')).should be_true
    end
    
    it "should increment the number at the end of the theme if it is a duplicate name" do
      Theme.create_from_zip_data(@zip_file, sites(:default))
      File.exists?(File.join(@base_dir, 'darker_2')).should be_true
    end
    
    it "should increment the number at the end of the theme if there already is one" do
      @zip_file = fixture_file_upload(File.join(%w(themes darker_2.zip)), 'application/zip')
      Theme.create_from_zip_data(@zip_file, sites(:default))
      Theme.create_from_zip_data(@zip_file, sites(:default))
      File.exists?(File.join(@base_dir, 'darker_3')).should be_true
    end
    
    it "should create the files in the root directory" do
      Theme.root_theme_files.each do |file|
        File.exists?(File.join(@base_dir, 'darker', file)).should be_true
      end
    end
    
    it "should create the standard directories in the theme" do
      Theme.theme_directories.each do |dir|
        File.exists?(File.join(@base_dir, 'darker', dir)).should be_true
      end
    end
    
    it "should copy in the files from the theme directories" do
      %w(contact.liquid home.liquid links.liquid news_items.liquid portfolio.liquid).each do |file|
        File.exists?(File.join(@base_dir, 'darker', 'templates', file)).should be_true
      end
    end
    
    it "should not allow file of the wrong file type" do
      File.exists?(File.join(@base_dir, 'darker', 'stylesheets', 'test.virus')).should be_false
    end
    
    it "should return the theme" do
      Theme.create_from_zip_data(@zip_file, sites(:default)).should eql(Theme.new('darker_2', sites(:default)))
    end
  end
  
  describe "destroying themes" do
    define_models :theme
    
    before(:each) do
      @zip_file = fixture_file_upload(File.join(%w(themes darker.zip)), 'application/zip')
      @theme = Theme.create_from_zip_data(@zip_file, sites(:default))
      @base_dir = Theme.site_theme_dir(sites(:default))
    end
    
    it "should destroy the theme directory when destroying the theme" do
      @theme.destroy
      File.exists?(File.join(@base_dir, 'darker')).should be_false
    end
  end
end
