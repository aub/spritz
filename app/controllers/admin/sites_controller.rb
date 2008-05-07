class Admin::SitesController < Admin::AdminController

  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]
  
  before_filter :admin_required, :except => [:new, :create]
  
  skip_before_filter :site_required, :only => [:new, :create]
  skip_before_filter :login_required, :only => [:new, :create]

  layout 'simple', :only => 'new'
  
  # GET /admin/sites
  # GET /admin/sites.xml
  def index
    @sites = Site.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sites }
    end
  end

  # GET /admin/sites/1
  # GET /admin/sites/1.xml
  def show
    @template_site = Site.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @template_site }
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
      @user.register!
      @user.activate!
    end
    respond_to do |format|
      if @template_site.save && @user.save
        @template_site.members << @user
        flash[:notice] = 'Site was successfully created.'
        format.html { redirect_to(dashboard_path) }
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
        flash[:notice] = 'Site was successfully updated.'
        format.html { redirect_to(admin_site_path(@template_site)) }
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
end
