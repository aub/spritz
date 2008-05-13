class Admin::PortfoliosController < Admin::AdminController
  
  before_filter :find_portfolio, :only => [:show, :edit, :update, :destroy, :reorder_children]
  
  # GET /admin/portfolios
  # GET /admin/portfolios.xml
  def index
    # This find helper will get the portfolios that are at the root of
    # the tree (i.e. they have no parent).
    @portfolios = @site.root_portfolios
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolios }
    end
  end

  # GET /admin/portfolios/1
  # GET /admin/portfolios/1.xml
  def show
    respond_to do |format|
      format.html { render_not_found }
      format.xml  { render :xml => @portfolio }
    end
  end

  # GET /admin/portfolios/new
  # GET /admin/portfolios/new.xml
  def new
    @portfolio = @site.portfolios.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portfolio }
    end
  end

  # This is the action for adding a child portfolio to an existing one.
  # TODO: Figure out how to make this more REST-ful.
  def add_child
    @portfolio = @site.portfolios.build
    @parent_id = params[:id]
    respond_to do |format|
      format.html { render :action => 'new' }
      format.xml  { render :xml => @portfolio }
    end
  end
  
  # GET /admin/portfolios/1/edit
  def edit
  end

  # POST /admin/portfolios
  # POST /admin/portfolios.xml
  def create
    # This is complicated because we may or may not have been given a parent id.
    # If a parent id is provided, we need to add the child that we're creating
    # to that parent. Call this helper method in the site to handle that.
    @portfolio = @site.portfolios.create_with_parent_id(params[:portfolio], params[:parent_id])
    respond_to do |format|
      if @portfolio.valid?
        flash[:notice] = 'Portfolio was successfully created.'
        format.html { redirect_to edit_admin_portfolio_path(@portfolio) }
        format.xml  { render :xml => @portfolio, :status => :created, :location => @portfolio }
      else
        # And finally, if we're going back to the 'new' template, we need to give it
        # the parent id again so it can add it to the form.
        @parent_id = params[:parent_id]
        format.html { render :action => "new" }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/portfolios/1
  # PUT /admin/portfolios/1.xml
  def update
    respond_to do |format|
      if @portfolio.update_attributes(params[:portfolio])
        flash[:notice] = 'Portfolio was successfully updated.'
        format.html { render :action => 'edit' }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/portfolios/1
  # DELETE /admin/portfolios/1.xml
  def destroy
    parent = @portfolio.parent
    @portfolio.destroy
    respond_to do |format|
      format.html do
        redirect_to(parent.nil? ? admin_portfolios_path : edit_admin_portfolio_path(parent))
      end
      format.xml  { head :ok }
    end
  end

  # PUT /portfolios/reorder
  def reorder
    site.root_portfolios.reorder! params[:portfolios]
    render :nothing => true
  end

  # PUT /portfolios/1/reorder_children
  def reorder_children
    @portfolio.reorder_children! params[:portfolios]
    render :nothing => true
  end
  
  protected
  
  def find_portfolio
    @portfolio = @site.portfolios.find(params[:id])
  end  
end
