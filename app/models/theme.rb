class Theme
  
  attr_reader :site, :name, :path
  
  def initialize(name, site)
    @name, @site = name, site
    @path = File.join(Theme.site_theme_dir(site), @name)
  end

  alias :to_param :name

  def active?
    @site.theme_path == @name
  end

  def layout
    File.join(%w(.. layouts default))
  end  
  
  def preview
    File.join(@path, 'preview.png')
  end
  
  def properties
    about_file = File.join(@path, 'about.yml')
    @properties ||= File.exist?(about_file) ? YAML.load_file(about_file) : {}
  end
  
  [:title, :version, :author, :author_email, :author_site, :summary].each do |attribute|
    eval <<-END
      def #{attribute}
        @#{attribute} ||= properties['#{attribute}']
      end
    END
  end
  
  def eql?(comparison_object)
    @site.eql?(comparison_object.site) && @path.eql?(comparison_object.path)
  end  
  
  def resources
    @resources ||= Pathname.glob(File.join(@path, '*/*')).collect { |path| path.file? ? Resource.new(self, path) : nil }.compact  
  end
  
  def resource(name)
    resources.detect { |r| r.name == name }
  end
  
  class << self
    def theme_root
      File.join(RAILS_ROOT, THEME_PATH_ROOT)
    end

    def defaults_directory
      File.join(theme_root, 'default')
    end
  
    def site_theme_dir(site)
      File.join(theme_root, "site-#{site.id}")
    end

    def find_all_for(site)
      themes = []
      dir = site_theme_dir(site)
      Dir.foreach dir do |path|
        next if path.first == '.' || !File.directory?(File.join(dir, path))
        themes << Theme.new(path, site)
      end
      themes.sort_by(&:path)
    end
  
    def create_defaults_for(site)
      begin
        FileUtils.cp_r(defaults_directory, site_theme_dir(site))
        true
      rescue
        false
      end
    end
  end
end
