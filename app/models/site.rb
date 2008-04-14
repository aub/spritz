class Site < ActiveRecord::Base

  include SettingsManager

  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :cache_items, :dependent => :destroy
  
  has_many :sections, :dependent => :destroy, :order => 'position' do
    def active
      find_all_by_active(true)
    end
  end
  
  serialize :settings, Hash

  setting :theme, :string, 'default'
  setting :title, :string, ''

  # Initialize the settings to something.
  def initialize(*args)
    super
    self.settings ||= {}
  end
  
  # A method for finding a site given a domain or subdomains from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain, subdomains)
    condition = subdomains.blank? ? ['domain = ?', domain] : ['domain = ? OR subdomain = ?', domain, subdomains.first]
    find(:first, :conditions => condition)
  end

  # A query method for the root of the action cache directory to use for this site. Preface the
  # directory with the site's subdomain so that the caches for different sites will be in different
  # directories. Also, put the test caches in a different folder.
  def action_cache_root
    subdomain
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
  
  def current_theme
    @current_theme ||= Theme.find(theme)
  end
  
  def to_liquid
    SiteDrop.new(self)
  end
end
