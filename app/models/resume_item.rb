class ResumeItem < ActiveRecord::Base

  acts_as_reorderable
  
  belongs_to :resume_section
  
  validates_presence_of :text
  
  column_to_html :text
  # before_save :convert_column_to_html
  
  def to_liquid
    ResumeItemDrop.new self
  end
  
  protected
  
  # def convert_column_to_html
  #   self.text_html = RedCloth.new(self.text || '').to_html
  # end
end
