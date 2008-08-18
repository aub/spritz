class Admin::SitesController < Admin::AdminController

  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]
  
  before_filter :admin_required, :except => [:new, :create]
  
  skip_before_filter :site_required, :only => [:new, :create]
  skip_before_filter :login_required, :only => [:new, :create]

  layout :set_layout
  
  # GET /admin/sites
  def index
    @sites = Site.find(:all)
  end

  # GET /admin/sites/new
  def new
    @template_site = Site.new
    @user = User.new
  end

  # GET /admin/sites/1/edit
  def edit
    @template_site = Site.find(params[:id])
  end

  # POST /admin/sites
  def create
    @template_site = Site.new(params[:site])
    @user = User.new(params[:user])
    if @template_site.valid? && @user.valid?
      @template_site.save
      @user.save
      # If the site and the user both save correctly, add the user as a member of the site and log them in.
      @template_site.members << @user
      self.current_user = @user
      flash[:notice] = "#{@template_site.title} was successfully created."
      redirect_to(admin_dashboard_path)
    else
      render( :action => 'new', :layout => 'simple' )
    end
  end

  # PUT /admin/sites/1
  def update
    @template_site = Site.find(params[:id])
    if @template_site.update_attributes(params[:site])
      flash[:notice] = 'Settings were successfully updated.'
      redirect_to(admin_path)
    else
      render :action => "edit"
    end
  end

  # DELETE /admin/sites/1
  def destroy
    @template_site = Site.find(params[:id])
    @template_site.destroy
    redirect_to(admin_sites_url)
  end
  
  protected
  
  def set_layout
    (request.parameters['action'] == 'new') ? 'simple' : 'admin'
  end
end
