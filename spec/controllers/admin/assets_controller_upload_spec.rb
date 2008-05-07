require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AssetsController do
  define_models :assets_controller
  
  num_thumbnails = 4
  
  before(:each) do
    activate_site :default
    login_as :admin
    FileUtils.rm_rf(ASSET_PATH_ROOT)
  end
  
  after(:each) do
    FileUtils.rm_rf(ASSET_PATH_ROOT)
  end
  
  describe "basic uploading" do
    define_models :assets_controller
    
    def do_post
      post :create, :asset => { :uploaded_data => asset_file }
    end
    
    it "should create an asset and its tunmbnails" do
      lambda { do_post }.should change(Asset, :count).by(num_thumbnails + 1)
    end
    
    it "should create the file in the correct location" do
      do_post
      File.exists?(File.join(path_root, 'icon.png')).should be_true
    end
    
    it "should create the thumbnailas as well" do
      do_post
      File.exists?(File.join(path_root, 'icon_display.png')).should be_true
      File.exists?(File.join(path_root, 'icon_thumb.png')).should be_true
      File.exists?(File.join(path_root, 'icon_tiny.png')).should be_true
    end
    
    it "should rename files with the same name to avoid conflicts" do
      do_post
      do_post
      File.exists?(File.join(path_root, 'icon_1.png')).should be_true
      File.exists?(File.join(path_root, 'icon_1_display.png')).should be_true
      File.exists?(File.join(path_root, 'icon_1_thumb.png')).should be_true
      File.exists?(File.join(path_root, 'icon_1_tiny.png')).should be_true
    end
  end
  
  protected
  
  def asset_file(options={})
    fixture_file_upload(File.join(%w(assets icon.png)), options[:content_type] || 'image/png')
  end
  
  def path_root
    t = Time.now
    File.join(ASSET_PATH_ROOT, sites(:default).subdomain, t.year.to_s, t.month.to_s, t.day.to_s)
  end
end