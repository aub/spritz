class Admin::GalleriesController < Admin::AdminController

  cache_sweeper :gallery_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /admin/galleries
  def index
    @galleries = @site.galleries
  end

  # GET /admin/galleries/new
  def new
    @gallery = @site.galleries.build
  end

  # GET /admin/galleries/1/edit
  def edit
    @gallery = @site.galleries.find(params[:id])
  end

  # POST /admin/galleries
  def create
    @gallery = @site.galleries.create(params[:gallery].reverse_merge({ :position => @site.last_gallery_position + 1 }))
    if @gallery.save
      flash[:notice] = 'Gallery was successfully created.'
      redirect_to admin_galleries_path
    else
      render :action => "new"
    end
  end

  # PUT /admin/galleries/1
  def update
    @gallery = @site.galleries.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      flash[:notice] = 'Gallery was successfully updated.'
      redirect_to admin_galleries_url
    else
      render :action => "edit"
    end
  end

  # PUT /admin/galleries/reorder
  def reorder
    site.galleries.reorder! params[:galleries]
    render :nothing => true
  end

  # DELETE /admin/galleries/1
  def destroy
    @gallery = @site.galleries.find(params[:id])
    @gallery.destroy
    redirect_to(admin_galleries_path)
  end
end
