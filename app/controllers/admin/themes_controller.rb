class Admin::ThemesController < Admin::AdminController
  
  before_filter :find_theme, :only => [:preview, :activate, :destroy]
  
  # GET /admin/themes
  def index
    @themes = @site.themes
  end

  def preview
    send_file(@theme.preview.to_s, :type => 'image/png', :disposition => 'inline')
  end

  # GET /admin/themes/new
  def new
  end

  # POST /admin/themes
  def create
    if Theme.create_from_zip_data(params[:zip_data], @site)
      flash[:notice] = 'Theme was successfully created.'
      redirect_to(admin_themes_path)
    else
      render :action => "new"
    end
  end

  # PUT /admin/themes/1/activate
  def activate
    if @theme && site.update_attribute(:theme_path, @theme.name)
      @site.cache_items.each { |ci| ci.expire!(self) }
      flash[:notice] = "#{@theme.name} was successfully activated."
    else
      flash[:error] = "Failed to activate the given theme."
    end
    redirect_to admin_themes_path
  end

  # DELETE /admin_themes/1
  def destroy
    if @theme.active?
      flash[:error] = 'Cannot delete the active theme.'
    else
      flash[:notice] = "Destroyed the theme: #{@theme.name}"
      @theme.destroy
    end    
    redirect_to(admin_themes_url)
  end
  
  protected
  
  def find_theme
    @theme = @site.find_theme(params[:id])
    render_not_found if @theme.nil?
  end
end
