class PortfolioSection < Section
  @@section_name = 'Portfolio'
  @@admin_controller = 'admin/portfolio_sections'
  cattr_reader :section_name, :admin_controller
  
  has_many :portfolio_pages, :foreign_key => 'section_id'

  def to_url
    [self.title]
  end
  
  def handle_request(request)
    [:portfolio, { :portfolio_pages => self.portfolio_pages }]
  end
  
  def to_liquid
    PortfolioSectionDrop.new self
  end
end