class ContentController < ApplicationController
  session :off
    
  before_filter :add_theme_directory_to_paths
  
  layout :theme_layout
  
  protected
  
  # We need to add the theme directory to two paths. The first is the view path, so
  # that Rails can find the templates to render them, and the second is the liquid
  # path, so that liquid can find partials to render.
  def add_theme_directory_to_paths
    self.prepend_view_path("#{@site.theme.path}/templates")
    self.prepend_view_path("#{@site.theme.path}")
    
    # Give the include tag access to files in the site's templates directory
    ::Liquid::Template.file_system = ::Liquid::LocalFileSystem.new(File.join(@site.theme.path, 'templates'))
  end
  
  def theme_layout
    @site.theme.layout
  end
end