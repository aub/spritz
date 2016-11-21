class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  
  validates_existence_of :user, :site
  validates_uniqueness_of :user_id, :scope => [:site_id]
end