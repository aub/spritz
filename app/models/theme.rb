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
    File.join(theme_root, 'default', name)
  end
  
  def self.theme_root
    File.join(RAILS_ROOT, THEME_PATH_ROOT)
  end

  def self.defaults_directory
    File.join(theme_root, 'default')
  end
  
  def self.site_theme_dir(site)
    File.join(theme_root, "site-#{site.id}")
  end
  
  def self.create_defaults(site)
    begin
      FileUtils.cp_r(defaults_directory, site_theme_dir(site))
      true
    rescue
      false
    end
  end
  
  def eql?(comparison_object)
    @name.eql?(comparison_object.name) && @path.eql?(comparison_object.path)
  end
end
