class Admin::ResourcesController < Admin::AdminController
  
  before_filter :find_theme
  before_filter :find_resource, :only => [:edit, :update]
  
  def index
  end
  
  def edit
  end

  def update
    @resource.write(params[:data])
    redirect_to edit_admin_theme_resource_path(@theme, @resource)
  end
  
  protected
  
  def find_theme
    @theme = params[:theme_id].nil? ? @site.theme : @site.find_theme(params[:theme_id])
  end
  
  def find_resource
    @resource = @theme.resource(params[:id])
  end
end