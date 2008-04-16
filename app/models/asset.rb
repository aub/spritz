class Asset < ActiveRecord::Base
  
  belongs_to :site

  has_attachment :storage => :file_system, 
                 :thumbnails => { :display => '600x400>', :thumb => '70x70!', :tiny => '35x35!' }, 
                 :max_size => 30.megabytes, 
                 :processor => (Object.const_defined?(:ASSET_IMAGE_PROCESSOR) ? ASSET_IMAGE_PROCESSOR : nil)
    
  validates_as_attachment
  validates_presence_of :site_id
  # validate :rename_unique_filename
  before_validation_on_create :set_site_from_parent
  
  protected
  
  def set_site_from_parent
    self.site_id = parent.site_id if parent_id
  end
  
end
