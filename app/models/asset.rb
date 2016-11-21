class Asset < ActiveRecord::Base
  
  FIELD_NAMES = [ :title, :medium, :dimensions, :date, :price, :description ]
  cattr_accessor :field_names
  
  belongs_to :site

  has_attached_file :attachment, :styles => Spritz::ASSET_STYLES
  
  has_many :assigned_assets, :dependent => :destroy
  
  attr_accessible :attachment, *FIELD_NAMES
    
  validates_attachment_presence :attachment
  
  validates_presence_of :site_id

  serialize :fields, Hash
    
  FIELD_NAMES.each do |f|
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
