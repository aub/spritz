class Asset < ActiveRecord::Base
  
  @@field_names = [ :title, :medium, :dimensions, :date, :price, :description ]
  cattr_accessor :field_names
  
  belongs_to :site

  has_attachment :storage => :file_system, 
                 :thumbnails => { :display => '600x400>', :medium => '400x300>', :thumb => '70x70!', :tiny => '35x35!' }, 
                 :max_size => 30.megabytes, 
                 :processor => (Object.const_defined?(:ASSET_IMAGE_PROCESSOR) ? ASSET_IMAGE_PROCESSOR : nil)

  # This has to be after has_attachment. It sets up the standard file locations, etc. for all
  # kinds of assets.
  acts_as_asset
  
  has_many :assigned_assets, :dependent => :destroy
  
  attr_accessible :uploaded_data, *@@field_names
    
  validates_as_attachment
  validates_presence_of :site_id

  serialize :fields, Hash
    
  @@field_names.each do |f|
    eval <<-END
      def #{f}
        (self.fields ||= {})[#{f.inspect}]
      end
      
      def #{f}=(value)
        (self.fields ||= {})[#{f.inspect}] = value
      end
    END
  end
end
