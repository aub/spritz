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
  
  it "should find the path for a given theme name" do
    Theme.theme_path('ack').should == File.join(RAILS_ROOT, THEME_PATH_ROOT, 'default', 'ack')
  end
  
  it "should have a find method for creating a theme with a given name" do
    Theme.find('booya').should eql(Theme.new('booya', File.join(RAILS_ROOT, THEME_PATH_ROOT, 'default', 'booya')))
  end
  
  it "should provide a useful equality operator" do
    Theme.new('a', File.join(RAILS_ROOT, 'a')).should eql(Theme.new('a', File.join(RAILS_ROOT, 'a')))
  end
  
  it "should provide the location of the theme" do
    Theme.find('testy').layout.should == File.join(%w(.. layouts default))
  end
  
  describe "create_defaults method" do
    define_models :theme
    
    it "should create a directory for the site's themes" do
      Theme.create_defaults(sites(:default))
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}")).should be_true
    end
    
    it "should copy the default themes into the site's directory" do
      Theme.create_defaults(sites(:default))
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'dark')).should be_true
      File.exist?(File.join(RAILS_ROOT, THEME_PATH_ROOT, "site-#{sites(:default).id}", 'light')).should be_true
    end
  end
  
  protected
  
  def cleanup_theme_directory
    Dir.foreach(Theme.theme_root) do |file|
      FileUtils.rm_rf(File.join(Theme.theme_root, file)) unless (file == 'default' || file == '.' || file == '..')
    end
  end
end
