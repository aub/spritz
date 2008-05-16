class Admin::SitesController < Admin::AdminController

  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]
  
  before_filter :admin_required, :except => [:new, :create]
  
  skip_before_filter :site_required, :only => [:new, :create]
  skip_before_filter :login_required, :only => [:new, :create]

  layout :set_layout
  
  # GET /admin/sites
  # GET /admin/sites.xml
  def index
    @sites = Site.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  # GET /admin/sites/new
  # GET /admin/sites/new.xml
  def new
    @template_site = Site.new
    @user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @template_site }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @template_site = Site.find(params[:id])
  end

  # POST /admin/sites
  # POST /admin/sites.xml
  def create
    @template_site = Site.new(params[:site])
    @user = User.new(params[:user])
    if @user.valid?
      @user.admin = true
    end
    respond_to do |format|
      if @template_site.save && @user.save
        # If the site and the user both save correctly, add the user as a member of the site and log them in.
        @template_site.members << @user
        self.current_user = @user
        flash[:notice] = "#{@template_site.title} was successfully created."
        format.html { redirect_to(admin_dashboard_path) }
        format.xml  { render :xml => @template_site, :status => :created, :location => @template_site }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @template_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.xml
  def update
    @template_site = Site.find(params[:id])
    respond_to do |format|
      if @template_site.update_attributes(params[:site])
        flash[:notice] = 'Settings were successfully updated.'
        format.html { redirect_to(admin_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @template_site.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.xml
  def destroy
    @template_site = Site.find(params[:id])
    @template_site.destroy
    respond_to do |format|
      format.html { redirect_to(admin_sites_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def set_layout
    (request.parameters['action'] == 'new') ? 'simple' : 'admin'
  end
end
