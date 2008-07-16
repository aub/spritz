class Admin::GalleriesController < Admin::AdminController

  cache_sweeper :gallery_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /admin/galleries
  # GET /admin/galleries.xml
  def index
    @galleries = @site.galleries
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @galleries }
    end
  end


  # GET /admin/galleries/1
  # GET /admin/galleries/1.xml
  def show
    @gallery = @site.galleries.find(params[:id])
    respond_to do |format|
      format.html { render_not_found }
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /admin/galleries/new
  # GET /admin/galleries/new.xml
  def new
    @gallery = @site.galleries.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gallery }
    end
  end

  # GET /admin/galleries/1/edit
  def edit
    @gallery = @site.galleries.find(params[:id])
  end

  # POST /admin/galleries
  # POST /admin/galleries.xml
  def create
    @gallery = @site.galleries.create(params[:gallery].reverse_merge({ :position => @site.last_gallery_position + 1 }))
    respond_to do |format|
      if @gallery.save
        flash[:notice] = 'Gallery was successfully created.'
        format.html { redirect_to admin_galleries_path }
        format.xml  { render :xml => @gallery, :status => :created, :location => @gallery }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/galleries/1
  # PUT /admin/galleries/1.xml
  def update
    @gallery = @site.galleries.find(params[:id])
    respond_to do |format|
      if @gallery.update_attributes(params[:gallery])
        flash[:notice] = 'Gallery was successfully updated.'
        format.html { redirect_to admin_galleries_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gallery.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/galleries/reorder
  def reorder
    site.galleries.reorder! params[:galleries]
    render :nothing => true
  end

  # DELETE /admin/galleries/1
  # DELETE /admin/galleries/1.xml
  def destroy
    @gallery = @site.galleries.find(params[:id])
    @gallery.destroy
    respond_to do |format|
      format.html { redirect_to(admin_galleries_path) }
      format.xml  { head :ok }
    end
  end
end
