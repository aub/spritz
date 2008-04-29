class LinkSection < Section
  @@section_name = 'Links'
  @@admin_controller = 'admin/link_sections'
  cattr_reader :section_name, :admin_controller
  
  has_many :links, :foreign_key => 'section_id'

  def handle_request(request)
    [:links, { :links => self.links }]
  end
  
  def to_liquid
    LinkSectionDrop.new self
  end
  
  def to_url
    ['link_sections', self.id]
  end
end