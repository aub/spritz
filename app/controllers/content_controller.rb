class ContentController < ApplicationController
  session :off
    
  before_filter :add_theme_directory_to_view_path
  
  layout :theme_layout
  
  protected
  
  def add_theme_directory_to_view_path
    self.prepend_view_path("#{@site.theme.path}/templates")
    self.prepend_view_path("#{@site.theme.path}")
  end
  
  def theme_layout
    @site.theme.layout
  end
end