class ContentController < ApplicationController
  
  before_filter :add_theme_directory_to_view_path
  
  layout :theme_layout
  
  protected
  
  def add_theme_directory_to_view_path
    self.prepend_view_path("#{@site.current_theme.path}/views")
  end
  
  def theme_layout
    @site.current_theme.layout
  end
end