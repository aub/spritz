class Section < ActiveRecord::Base
  
  belongs_to :site

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :site_id
  validates_presence_of :site_id

  def to_liquid
    SectionDrop.new self
  end
end