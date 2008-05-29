class Site < ActiveRecord::Base

  @@multi_sites_enabled = false
  cattr_accessor :multi_sites_enabled

  validates_presence_of :title
  validates_numericality_of :home_news_item_count, :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true

  after_create :initialize_theme

  # column_to_html :home_text
  before_save :convert_column_to_html

  attr_accessible :subdomain, :domain, :theme_path, :title, :home_news_item_count, :home_text, :google_analytics_code
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :cache_items, :dependent => :destroy

  has_many :assets, :dependent => :destroy, :conditions => 'parent_id is NULL'

  has_many :links, :dependent => :destroy, :order => :position do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

  has_many :news_items, :dependent => :destroy, :order => :position do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

  has_many :resume_sections, :dependent => :destroy, :order => :position do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

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
  has_many :root_portfolios, :class_name => 'Portfolio', :conditions => 'parent_id is NULL', :order => :position, :dependent => :destroy do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, Portfolio, sorted_ids)
    end    
  end

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
  # directories if multisite is enabled.
  def action_cache_root
    Site.multi_sites_enabled ? subdomain : ''
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

  def user_by_email(email)
    User.find_by_email(self, email)
  end
  
  def themes
    Theme.find_all_for(self)
  end
  
  def theme
    find_theme(theme_path)
  end
  
  def find_theme(name)
    themes.find { |t| t.name == name }
  end
  
  # Helper method for getting the position of the last news item in the list.
  def last_news_item_position
    (news_items.size > 0) ? news_items.last.position : 0
  end
  
  # Helper method for getting the position of the last link in the list.
  def last_link_position
    (links.size > 0) ? links.last.position : 0
  end
  
  # See above...
  def last_portfolio_position
    (root_portfolios.size > 0) ? root_portfolios.last.position : 0
  end
  
  # See above...
  def last_resume_section_position
    (resume_sections.size > 0) ? resume_sections.last.position : 0
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
  
  # A helper method for reordering items that belong to the site.
  def reorder_items(list, *sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |thing_id, pos|
        list.find(thing_id).update_attribute(:position, pos)
      end
    end
  end
  
  def convert_column_to_html
    self.home_text_html = RedCloth.new(self.home_text || '').to_html
  end  
end
