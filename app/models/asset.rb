class Asset < ActiveRecord::Base
  
  belongs_to :site

  has_attachment :storage => :file_system, 
                 :thumbnails => { :display => '600x400>', :thumb => '70x70!', :tiny => '35x35!' }, 
                 :max_size => 30.megabytes, 
                 :processor => (Object.const_defined?(:ASSET_IMAGE_PROCESSOR) ? ASSET_IMAGE_PROCESSOR : nil)

  # This has to be after has_attachment. It sets up the standard file locations, etc. for all
  # kinds of assets.
  acts_as_asset
  
    
  validates_as_attachment
  validates_presence_of :site_id
        
end
