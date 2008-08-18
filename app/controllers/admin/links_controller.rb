class Admin::LinksController < Admin::AdminController

  cache_sweeper :link_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /links
  def index
    @links = @site.links
  end

  # GET /links/new
  def new
    @link = @site.links.build
  end

  # GET /links/1/edit
  def edit
    @link = @site.links.find(params[:id])
  end

  # POST /links
  def create
    @link = @site.links.create(params[:link].reverse_merge({ :position => @site.last_link_position + 1 }))
    if @link.valid?
      flash[:notice] = 'Link was successfully created.'
      redirect_to admin_links_url
    else
      render :action => "new"
    end
  end

  # PUT /links/1
  def update
    @link = @site.links.find(params[:id])
    if @link.update_attributes(params[:link])
      flash[:notice] = 'Link was successfully updated.'
      redirect_to admin_links_url
    else
      render :action => "edit"
    end
  end

  # PUT /links/reorder
  def reorder
    site.links.reorder! params[:links]
    render :nothing => true
  end

  # DELETE /links/1
  def destroy
    @link = @site.links.find(params[:id])
    @link.destroy
    redirect_to admin_links_url
  end
end
