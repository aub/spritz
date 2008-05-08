class Site < ActiveRecord::Base

  @@multi_sites_enables = false
  cattr_accessor :multi_sites_enabled

  validates_presence_of :title
  validates_numericality_of :home_news_item_count, :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true

  after_create :initialize_theme

  attr_accessible :subdomain, :domain, :theme_path, :title, :home_news_item_count, :home_text
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :cache_items, :dependent => :destroy

  has_many :assets, :dependent => :destroy, :conditions => 'parent_id is NULL'

  has_many :links, :dependent => :destroy

  has_many :news_items, :dependent => :destroy

  has_many :contacts, :dependent => :destroy

  has_many :portfolios do
    # A helper method for creating portfolios as children of another one. This does
    # the wranging of acts_as_nested_set for us.
    def create_with_parent_id(params, parent_id)
      returning proxy_owner.portfolios.create(params) do |portfolio|
        if portfolio.valid?
          parent = Portfolio.find_by_id_and_site_id(parent_id, proxy_owner.id)
          unless parent.nil?
            portfolio.move_to_child_of(parent)
          end
        end
      end
    end
  end

  # This is necessary both because it's nice to get access to only the root level portfolios
  # and because and because we only want to destroy the top ones when the site is being destroyed,
  # since the plugin will handle deletion of the children.
  has_many :root_portfolios, :class_name => 'Portfolio', :conditions => 'parent_id is NULL', :dependent => :destroy

  has_one :assigned_home_image, :class_name => 'AssignedAsset', :as => :asset_holder, :dependent => :destroy

  # This will have to do until we have has_one :through
  def home_image
    assigned_home_image.asset unless assigned_home_image.nil?
  end

  # A method for finding a site given a domain or subdomains from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain, subdomains)
    if multi_sites_enabled
      condition = subdomains.blank? ? ['domain = ?', domain] : ['domain = ? OR subdomain = ?', domain, subdomains.first]
      find(:first, :conditions => condition)
    else
      find(:first)
    end
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
  
  def themes
    @themes ||= Theme.find_all_for(self)
  end
  
  def theme
    find_theme(theme_path)
  end
  
  def find_theme(name)
    themes.find { |t| t.name == name }
  end
  
  def to_liquid
    SiteDrop.new(self)
  end
  
  protected
  
  def initialize_theme
    self.update_attribute(:theme_path, 'dark')
    # This needs to be last because we want to return false if it fails
    Theme.create_defaults_for(self)
  end
end
