class Admin::PortfoliosController < Admin::AdminController
  
  before_filter :find_portfolio, :only => [:show, :edit, :update, :destroy, :reorder_children]
  
  cache_sweeper :portfolio_sweeper, :only => [:create, :update, :destroy, :reorder, :reorder_children]
  
  # GET /admin/portfolios
  def index
    # This find helper will get the portfolios that are at the root of
    # the tree (i.e. they have no parent).
    @portfolios = @site.root_portfolios
  end

  # GET /admin/portfolios/new
  def new
    @portfolio = @site.portfolios.build
  end

  # This is the action for adding a child portfolio to an existing one.
  # TODO: Figure out how to make this more REST-ful.
  def add_child
    @portfolio = @site.portfolios.build
    @parent_id = params[:id]
    render :action => 'new'
  end
  
  # GET /admin/portfolios/1/edit
  def edit
  end

  # POST /admin/portfolios
  def create
    # Force the new portfolio to be after the last existing one. In the case where we're adding
    # a sub-page, the position won't matter because acts_as_nested_set will take care of the ordering.
    params[:portfolio].reverse_merge!({ :position => @site.last_portfolio_position + 1 })
    
    # This is complicated because we may or may not have been given a parent id.
    # If a parent id is provided, we need to add the child that we're creating
    # to that parent. Call this helper method in the site to handle that.
    @portfolio = @site.portfolios.create_with_parent_id(params[:portfolio], params[:parent_id])
    if @portfolio.valid?
      flash[:notice] = 'Portfolio was successfully created.'
      redirect_to edit_admin_portfolio_path(@portfolio)
    else
      # And finally, if we're going back to the 'new' template, we need to give it
      # the parent id again so it can add it to the form.
      @parent_id = params[:parent_id]
      render :action => "new"
    end
  end

  # PUT /admin/portfolios/1
  def update
    if @portfolio.update_attributes(params[:portfolio])
      flash[:notice] = 'Portfolio was successfully updated.'
    end
    render :action => 'edit'
  end

  # DELETE /admin/portfolios/1
  def destroy
    parent = @portfolio.parent
    @portfolio.destroy
    redirect_to(parent.nil? ? admin_portfolios_path : edit_admin_portfolio_path(parent))
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
