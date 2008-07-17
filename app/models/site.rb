class Site < ActiveRecord::Base

  validates_presence_of :title
  validates_numericality_of :home_news_item_count, :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true
  validates_uniqueness_of :domain

  after_create :initialize_theme

  # column_to_html :home_text
  before_save :convert_column_to_html

  attr_accessible :domain, :theme_path, :title, :home_news_item_count, :home_text, :google_analytics_code
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :cache_items, :dependent => :destroy

  has_many :assets, :dependent => :destroy, :conditions => 'parent_id is NULL'

  has_many :galleries, :dependent => :destroy, :order => 'position' do
    # change the order of the galleries in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

  has_many :links, :dependent => :destroy, :order => 'position' do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

  has_many :news_items, :dependent => :destroy, :order => 'position' do
    # change the order of the links in the site by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_items, self, sorted_ids)
    end
  end

  has_many :resume_sections, :dependent => :destroy, :order => 'position' do
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
            portfolio.save # This is necessary in order to get the sweeper to be called.
          end
        end
      end
    end
  end

  # This is necessary both because it's nice to get access to only the root level portfolios
  # and because and because we only want to destroy the top ones when the site is being destroyed,
  # since the plugin will handle deletion of the children.
  has_many :root_portfolios, :class_name => 'Portfolio', :conditions => 'parent_id is NULL', :order => 'position', :dependent => :destroy do
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

  # A method for finding a site given a domain from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain)
    if Spritz.multi_sites_enabled
      find(:first, :conditions => ['domain = ?', domain])
    else
      find(:first)
    end
  end

  # A query method for the root of the action cache directory to use for this site. Preface the
  # directory with the site's domain so that the caches for different sites will be in different
  # directories if multisite is enabled.
  def action_cache_root
    Spritz.multi_sites_enabled ? domain : ''
  end
  
  # And similarly for page caching.
  def page_cache_path
    Spritz.multi_sites_enabled ? 
      (Pathname.new(RAILS_ROOT) + (RAILS_ENV == 'test' ? 'tmp' : 'public') + 'cache' + domain) :
      (Pathname.new(RAILS_ROOT) + (RAILS_ENV == 'test' ? 'tmp/cache' : 'public'))
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
  
  # # Create helper methods for getting the position of the last item in the list for the various associations.
  { 'news_item' => 'news_items', 'link' => 'links', 'portfolio' => 'root_portfolios', 'resume_section' => 'resume_sections', 'gallery' => 'galleries' }.each do |title,association|
    define_method("last_#{title}_position") do
      (send(association).size > 0) ? send(association).last.position : 0
    end
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
