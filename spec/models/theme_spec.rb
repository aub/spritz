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
  end
  
  describe "find_all_for method" do
    define_models :theme
    
    it "should create a list of themes for the given site" do
      Theme.create_defaults_for(sites(:default))
      Theme.find_all_for(sites(:default)).should eql([Theme.new('dark', sites(:default)), Theme.new('light', sites(:default))])
    end
  end
  
  protected
  
  def cleanup_theme_directory
    Dir.foreach(Theme.theme_root) do |file|
      FileUtils.rm_rf(File.join(Theme.theme_root, file)) unless (file == 'default' || file == '.' || file == '..')
    end
  end
end
