class Site < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :subdomain, :if => Proc.new { Spritz.multi_sites_enabled }
  validates_numericality_of :home_news_item_count, :only_integer => true, :less_than_or_equal_to => 10, :allow_nil => true
  validates_uniqueness_of :subdomain, :allow_blank => true
  validates_uniqueness_of :domain, :allow_blank => true

  after_create :initialize_theme

  column_to_html :home_text

  attr_accessible :domain, :subdomain, :theme_path, :title, :home_news_item_count, :home_text, :home_image, :google_analytics_code
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  
  has_many :cache_items, :dependent => :destroy

  has_many :assets, :dependent => :destroy

  has_many :galleries, :dependent => :destroy, :order => 'position'

  has_many :links, :dependent => :destroy, :order => 'position'

  has_many :news_items, :dependent => :destroy, :order => 'position'

  has_many :resume_sections, :dependent => :destroy, :order => 'position'

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
  # since the nested set plugin will handle deletion of the children.
  has_many :root_portfolios, :class_name => 'Portfolio', :conditions => 'parent_id is NULL', :order => 'position', :dependent => :destroy

  has_attached_file :home_image, :styles => Spritz::ASSET_STYLES

  # A method for finding a site given a domain from a request.
  # Will be called with every request in order to display the correct data.
  def self.for(domain, subdomains)
    if Spritz.multi_sites_enabled
      condition = subdomains.blank? ? ['domain = ?', domain] : ['domain = ? OR subdomain = ?', domain, subdomains.first]
      find(:first, :conditions => condition)
    else
      find(:first)
    end
  end

  # A query method for the root of the page cache directory to use for this site. Preface the
  # directory with the site's domain so that the caches for different sites will be in different
  # directories if multisite is enabled.
  def page_cache_path
    Spritz.multi_sites_enabled ? 
      (Pathname.new(RAILS_ROOT) + (RAILS_ENV == 'test' ? 'tmp' : 'public') + 'cache' + subdomain) :
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
end
