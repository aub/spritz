class Theme
  
  attr_reader :name, :path
  
  def initialize(name, path)
    @name, @path = name, path
  end
  
  def layout
    File.join(%w(.. layouts default))
  end
  
  def self.find(name)
    self.new(name, theme_path(name))
  end
  
  def self.theme_path(name)
    File.join(theme_root, name)
  end
  
  def self.theme_root
    File.join(RAILS_ROOT, ((RAILS_ENV == 'test') ? %w(tmp themes) : 'themes'))
  end
  
  def eql?(comparison_object)
    @name.eql?(comparison_object.name) && @path.eql?(comparison_object.path)
  end
end
