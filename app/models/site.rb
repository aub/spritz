class Site < ActiveRecord::Base

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  # A method for finding a site given a domain or subdomains from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain, subdomains)
    condition = subdomains.blank? ? ['domain = ?', domain] : ['domain = ? OR subdomain = ?', domain, subdomains.first]
    find(:first, :conditions => condition)
  end
  
  # A collection of methods to help with finding users for this site
  # using the handy finder methods in the user object that take a site.
  def users(options = {})
    User.find_all_by_site self, options
  end
  
  def user(id)
    User.find_by_site self, id
  end
  
  def user_by_remember_token(token)
    User.find_by_remember_token(self, token)
  end
end
