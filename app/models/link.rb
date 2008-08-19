class Link < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :site
  
  validates_presence_of :url, :title
  validates_length_of :url, :minimum => 3
  
  attr_accessible :url, :title, :position
  
  before_save :append_http_to_url
  
  def to_liquid
    LinkDrop.new self
  end
  
  protected
  
  def append_http_to_url
    self.url = "http://#{url}" unless self.url.blank? || self.url =~ /^http:\/\//
  end
end
