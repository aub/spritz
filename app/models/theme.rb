require 'zip/zipfilesystem'

class Theme
  @@root_theme_files   = %w(about.yml preview.png)
  @@theme_directories  = %w(images javascripts layouts stylesheets templates)
  @@allowed_extensions = %w(.js .css .png .gif .jpg .swf .ico .liquid)
  cattr_reader :root_theme_files, :theme_directories, :allowed_extensions
  
  attr_reader :site, :name, :path
  
  def initialize(name, site)
    @name, @site = name, site
    @path = Pathname.new(File.join(Theme.site_theme_dir(site), @name))
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
    self == (comparison_object)
  end
  
  def ==(comparison_object)
    @path == comparison_object.path && @site == comparison_object.site
  end
  
  def resources
    Pathname.glob(File.join(@path, '*/*')).collect { |path| path.file? ? Resource.new(self, path) : nil }.compact
  end
  
  def resource(name)
    resources.detect { |r| r.name == name }
  end
  
  def destroy
    self.path.rmtree
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
        # Get rid of the directory first to make sure we start from scratch.
        FileUtils.rm_rf(site_theme_dir(site))
        FileUtils.cp_r(defaults_directory, site_theme_dir(site))
        true
      rescue
        false
      end
    end
    
    def create_from_zip_data(zip_file, site)
      # Get the file name from the zip file and replace the unpleasant parts.
      filename = zip_file.original_filename
      filename.gsub!(/(^.*(\\|\/))|(\.zip$)/, '')
      filename.gsub!(/[^\w\.\-]/, '_')

      # Now, see if a file already exists with that name, and if so change the
      # name by appending a number to it that will increment until no such file
      # exists.
      dest        = Pathname.new(File.join(site_theme_dir(site), filename))
      basename    = dest.basename.to_s
      if dest.exist?
        basename  = basename =~ /(.*)_(\d+)$/ ? $1 : basename
        number    = $2 ? $2.to_i + 1 : 2
        dirname   = dest.dirname
        dest      = dirname + "#{basename}_#{number}"
        while dest.exist?
          number += 1
          dest    = dirname + "#{basename}_#{number}"
        end
      end

      # Create the destination directory
      FileUtils.mkdir_p dest.to_s unless dest.exist?
      
      # Open the zip file
      Zip::ZipFile.open(zip_file.path) do |z|
        
        # For each of the files that are supposed to be in the root directory of the theme,
        # read them from the zip file and create files in the theme directory for them.
        root_theme_files.each do |file|
          z.file.open(file) { |zf| File.open(dest + file, 'wb') { |f| f << zf.read } } if z.file.exist?(file)
        end
        
        # For each of the directories that are supposed to exist in the theme, copy the files
        # into the new theme directory.
        theme_directories.each do |dir|
          dir_path = Pathname.new(dest + dir)
          FileUtils.mkdir_p dir_path unless dir_path.exist?
          z.dir.entries(dir).each do |entry|
            # Make sure that the files conform to a naming comvention so that users don't upload
            # crazy things (or viruses).
            next unless entry =~ /(\.\w+)$/ && allowed_extensions.include?($1)
            z.file.open(File.join(dir, entry)) { |zf| File.open(dir_path + entry, 'wb') { |f| f << zf.read } }
          end
        end
      end
      Theme.new(dest.basename.to_s, site)
    rescue
      # If the upload fails, delete the directory that we were trying to upload to
      # and rethrow the exception.
      dest.rmtree if dest.exist?
      raise $!
    end
  end
end
