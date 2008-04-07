class Site < ActiveRecord::Base
  
  # A method for finding a site given a domain or subdomains from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain, subdomains)
    condition = subdomains.blank? ? ['domain = ?', domain] : ['domain = ? OR subdomain = ?', domain, subdomains.first]
    find(:first, :conditions => condition)
  end
  
end
