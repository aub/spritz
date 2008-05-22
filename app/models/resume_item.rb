class ResumeItem < ActiveRecord::Base
  
  belongs_to :resume_section
  
  validates_presence_of :text
  
end
