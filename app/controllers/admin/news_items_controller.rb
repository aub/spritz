class Admin::NewsItemsController < Admin::AdminController

  cache_sweeper :news_item_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /admin/news_items
  def index
    @news_items = @site.news_items.find(:all)
  end
  
  # GET /admin/news_items/1
  def show
    @news_item = @site.news_items.find(params[:id])
  end

  # GET /admin/news_items/new
  def new
    @news_item = @site.news_items.build
  end

  # GET /admin/news_items/1/edit
  def edit
    @news_item = @site.news_items.find(params[:id])
  end

  # POST /admin/news_items
  def create
    # Make sure the item goes on the end of the list.
    @news_item = @site.news_items.create(params[:news_item].reverse_merge({ :position => @site.last_news_item_position + 1 }))
    if @news_item.valid?
      flash[:notice] = 'NewsItem was successfully created.'
      redirect_to admin_news_items_path
    else
      render :action => "new"
    end
  end

  # PUT /admin/news_items/1
  def update
    @news_item = @site.news_items.find(params[:id])
    if @news_item.update_attributes(params[:news_item])
      flash[:notice] = 'NewsItem was successfully updated.'
      redirect_to admin_news_items_path
    else
      render :action => "edit"
    end
  end

  # PUT /news_items/reorder
  def reorder
    site.news_items.reorder! params[:news_items]
    render :nothing => true
  end

  # DELETE /admin/news_items/1
  def destroy
    @news_item = @site.news_items.find(params[:id])
    @news_item.destroy
    redirect_to admin_news_items_path
  end
end
