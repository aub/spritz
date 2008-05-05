class Admin::ThemesController < Admin::AdminController
  
  before_filter :find_theme, :only => [:preview, :activate]
  
  # GET /admin/themes
  # GET /admin/themes.xml
  def index
    @themes = @site.themes
    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @themes }
    end
  end

  def preview
    send_file(@theme.preview.to_s, :type => 'image/png', :disposition => 'inline')
  end

  # GET /admin/themes/new
  # GET /admin/themes/new.xml
  def new
    # respond_to do |format|
    #   format.html # new.html.erb
    # end
  end

  # POST /admin/themes
  # POST /admin/themes.xml
  def create
    # @theme = Admin::Theme.new(params[:theme])
    # 
    # respond_to do |format|
    #   if @theme.save
    #     flash[:notice] = 'Admin::Theme was successfully created.'
    #     format.html { redirect_to(@theme) }
    #     format.xml  { render :xml => @theme, :status => :created, :location => @theme }
    #   else
    #     format.html { render :action => "new" }
    #     format.xml  { render :xml => @theme.errors, :status => :unprocessable_entity }
    #   end
    # end
  end

  # PUT /admin/themes/1/activate
  # PUT /admin/themes/1/activate.xml
  def activate
    respond_to do |format|
      if @theme && site.update_attribute(:theme_path, @theme.name)
        flash[:notice] = "#{@theme.name} was successfully activated."
      else
        flash[:error] = "Failed to activate the given theme."
      end
      format.html { redirect_to admin_themes_path }
    end
  end

  # DELETE /admin_themes/1
  # DELETE /admin_themes/1.xml
  def destroy
    # @theme = Admin::Theme.find(params[:id])
    # @theme.destroy
    # 
    # respond_to do |format|
    #   format.html { redirect_to(admin_themes_url) }
    #   format.xml  { head :ok }
    # end
  end
  
  protected
  
  def find_theme
    @theme = @site.find_theme(params[:id])
    render_not_found if @theme.nil?
  end
end
