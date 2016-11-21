class ResumeSection < ActiveRecord::Base
  
  acts_as_reorderable
  
  belongs_to :site
  
  has_many :resume_items, :order => 'position', :dependent => :destroy
  
  validates_presence_of :title

  def to_liquid
    ResumeSectionDrop.new self
  end    
end
