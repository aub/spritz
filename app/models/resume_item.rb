class ResumeItem < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :resume_section
  
  validates_presence_of :text
  
  column_to_html :text
  
  def to_liquid
    ResumeItemDrop.new self
  end
end
