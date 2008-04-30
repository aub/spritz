class Admin::PortfoliosController < Admin::AdminController
  # GET /admin/portfolios
  # GET /admin/portfolios.xml
  def index
    @portfolios = @site.portfolios
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portfolios }
    end
  end

  # GET /admin/portfolios/1
  # GET /admin/portfolios/1.xml
  def show
    @portfolio = @site.portfolios.find(params[:id])
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
    @portfolio = @site.portfolios.find(params[:id])
  end

  # POST /admin/portfolios
  # POST /admin/portfolios.xml
  def create
    @portfolio = @site.portfolios.create_with_parent_id(params[:portfolio], params[:parent_id])
    respond_to do |format|
      if @portfolio.valid?
        flash[:notice] = 'Portfolio was successfully created.'
        format.html do 
          if params[:parent_id]
            redirect_to edit_admin_portfolio_path(params[:parent_id])
          else
            redirect_to admin_portfolios_path
          end
        end
        format.xml  { render :xml => @portfolio, :status => :created, :location => @portfolio }
      else
        @parent_id = params[:parent_id]
        format.html { render :action => "new" }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/portfolios/1
  # PUT /admin/portfolios/1.xml
  def update
    @portfolio = @site.portfolios.find(params[:id])
    respond_to do |format|
      if @portfolio.update_attributes(params[:portfolio])
        flash[:notice] = 'Portfolio was successfully updated.'
        format.html { redirect_to admin_portfolios_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portfolio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/portfolios/1
  # DELETE /admin/portfolios/1.xml
  def destroy
    @portfolio = @site.portfolios.find(params[:id])
    @portfolio.destroy
    respond_to do |format|
      format.html { redirect_to admin_portfolios_path }
      format.xml  { head :ok }
    end
  end
end
