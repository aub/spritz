class ThemeController < ContentController
  session :off
  
  def stylesheets
    render_theme_item(:stylesheets, params[:filename], params[:ext], false)
  end
  
  def javascripts
    render_theme_item(:javascripts, params[:filename], params[:ext], false)
  end
  
  def images
    render_theme_item(:images, params[:filename], params[:ext], true)
  end
  
  def render_theme_item(type, filename, extension, is_image)
    # For safety, make sure we don't allow access to the other system directories
    if filename.split(/\//).include?("..")
      render_not_found and return
    end
    
    # Construct the full path to the file and make sure it exists.
    resource = Pathname.new(File.join(@site.current_theme.path, self.action_name, [filename, extension] * '.'))
    render_not_found and return unless resource.file?
    
    content_type = mime_for(extension)
    if is_image
      send_data resource.read, :filename => resource.basename.to_s, :type => content_type, :disposition => 'inline'
    else
      headers['Content-Type'] = content_type
      render :text => resource.read
    end
  end
  
  protected
  
  def mime_for(extension)
    case extension.downcase
    when /^js$/
      'text/javascript'
    when /^css$/
      'text/css'
    when /^gif$/
      'image/gif'
    when /^(jpg|jpeg)$/
      'image/jpeg'
    when /^png$/
      'image/png'
    when /^swf$/
      'application/x-shockwave-flash'
    else
      'application/binary'
    end
  end
  
end