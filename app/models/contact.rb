class Contact < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :email, :name
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i
  
end
