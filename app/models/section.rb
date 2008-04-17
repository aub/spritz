class Section < ActiveRecord::Base
  
  belongs_to :site

  validates_presence_of :title
  validates_uniqueness_of :title, :scope => :site_id
  validates_presence_of :site_id

  def to_liquid
    SectionDrop.new self
  end
end