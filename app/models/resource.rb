class Resource
  
  attr_reader :path, :theme
  
  def initialize(theme, path)
    @theme, @path = theme, path
  end
  
  def eql?(comparison_object)
    self == (comparison_object)
  end
  
  def ==(comparison_object)
    @path == comparison_object.path && @theme == comparison_object.theme
  end
  
  def filename
    @path.split.last.to_s
  end
  
  def name
    @name ||= escape(filename)
  end

  alias :to_param :name
  
  def write(data = nil)
    unless data.nil?
      File.open(@path, 'wb') { |f| f.write data }
    end
  end
  
  def read
    File.open(@path, 'r').read
  end
  
  def destroy
    FileUtils.rm(@path)
  end
  
  def image?
    # Because Asset is using attachment_fu, it gets a method that will
    # help us here.
    Asset.image?(content_type)
  end
  
  {'template?' => '.liquid', 'stylesheet?' => '.css', 'javascript?' => '.js' }.each do |key, value|
    eval <<-END
      def #{key}
        path.extname == '#{value}'
      end
    END
  end
  
  def content_type
    @content_type ||= 
      case path.extname
        when '.js'           then 'text/javascript'
        when '.css'          then 'text/css'
        when '.png'          then 'image/png'
        when '.jpg', '.jpeg' then 'image/jpeg'
        when '.gif'          then 'image/gif'
        when '.swf'          then 'application/x-shockwave-flash'
        when '.ico'          then 'image/x-icon'
    end
  end
  
  protected
  
  # Change a name into something we can use in a URL. Borrowed from Permalink_fu
  def escape(s)
    s.gsub!(/\W+/, ' ') # all non-word chars to spaces
    s.strip!            # ohh la la
    s.downcase!         #
    s.gsub!(/\ +/, '-') # spaces to dashes, preferred separator char everywhere
    s
  end
end