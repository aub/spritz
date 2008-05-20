class ResumeSection < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :title
  
end
