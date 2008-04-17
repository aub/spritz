class PortfolioSection < Section
  @@section_name = 'Portfolio'
  @@admin_controller = 'admin/portfolio_sections'
  cattr_reader :section_name, :admin_controller

  after_create :create_default_portfolio

  # This is the root of the portfolio page tree
  has_one :portfolio, :class_name => 'PortfolioPage', :conditions => 'parent_id is null', :foreign_key => 'section_id'
  has_many :portfolio_pages, :foreign_key => 'section_id', :dependent => :destroy

  def to_url
    [self.title]
  end
  
  def handle_request(request)
    [:portfolio, { :portfolio_pages => self.portfolio_pages }]
  end
  
  def to_liquid
    PortfolioSectionDrop.new self
  end
  
  protected
  
  def create_default_portfolio
    portfolio_page = build_portfolio
    portfolio_page.name = 'Portfolio'
    portfolio_page.path = 'portfolio'
    portfolio_page.save
  end  
  
end