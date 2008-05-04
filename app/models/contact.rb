class Contact < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :email, :message => 'Please provide your email address'
  validates_presence_of :name, :message => 'Please provide your name'
  validates_format_of :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i, :message => 'Please provide a valid email address'
  
  def to_liquid
    ContactDrop.new self
  end
  
end
