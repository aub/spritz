class Admin::NewsItemsController < Admin::AdminController
  # GET /admin/news_items
  # GET /admin/news_items.xml
  def index
    @news_items = @site.news_items.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @news_items }
    end
  end

  # GET /admin/news_items/1
  # GET /admin/news_items/1.xml
  def show
    @news_item = @site.news_items.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @news_item }
    end
  end

  # GET /admin/news_items/new
  # GET /admin/news_items/new.xml
  def new
    @news_item = @site.news_items.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @news_item }
    end
  end

  # GET /admin/news_items/1/edit
  def edit
    @news_item = @site.news_items.find(params[:id])
  end

  # POST /admin/news_items
  # POST /admin/news_items.xml
  def create
    @news_item = @site.news_items.build(params[:news_item])
    respond_to do |format|
      if @news_item.save
        flash[:notice] = 'NewsItem was successfully created.'
        format.html { redirect_to admin_news_items_path }
        format.xml  { render :xml => @news_item, :status => :created, :location => @news_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/news_items/1
  # PUT /admin/news_items/1.xml
  def update
    @news_item = @site.news_items.find(params[:id])
    respond_to do |format|
      if @news_item.update_attributes(params[:news_item])
        flash[:notice] = 'NewsItem was successfully updated.'
        format.html { redirect_to admin_news_items_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /news_items/reorder
  def reorder
    site.news_items.reorder! params[:news_items]
    render :nothing => true
  end

  # DELETE /admin/news_items/1
  # DELETE /admin/news_items/1.xml
  def destroy
    @news_item = @site.news_items.find(params[:id])
    @news_item.destroy
    respond_to do |format|
      format.html { redirect_to admin_news_items_path }
      format.xml  { head :ok }
    end
  end
end
