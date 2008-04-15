class LinkSection < Section
  @@name = 'Links'
  @@admin_controller = 'admin/link_sections'
  cattr_accessor :name, :admin_controller
  
  has_many :links, :foreign_key => 'section_id'

  def to_url
    ['link_sections', self.id]
  end
  
  def handle_request(request)
    [:links, { :links => self.links }]
  end
end