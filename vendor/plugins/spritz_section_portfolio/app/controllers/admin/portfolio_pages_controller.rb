class Admin::PortfolioPagesController < Admin::AdminController
  
  before_filter :find_section

  # GET /admin/sites/new
  # GET /admin/sites/new.xml
  def new
    @portfolio_page = @section.portfolio_pages.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portfolio_page }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @portfolio_page = @section.portfolio_pages.find(params[:id])
  end

  # POST /admin/sites
  # POST /admin/sites.xml
  def create
    @portfolio_page = @section.portfolio_pages.build(params[:portfolio_page])

    respond_to do |format|
      if @portfolio_page.save
        flash[:notice] = 'Portfolio page was successfully created.'
        format.html { redirect_to(admin_portfolio_section_path(@section)) }
        format.xml  { render :xml => @section, :status => :created, :location => @portfolio_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @portfolio_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.xml
  def update
    @portfolio_page = @section.portfolio_pages.find(params[:id])

    respond_to do |format|
      if @portfolio_page.update_attributes(params[:portfolio_page])
        flash[:notice] = 'portfolio page was successfully updated.'
        format.html { redirect_to(admin_portfolio_section_path(@section)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/sites/1
  # DELETE /admin/sites/1.xml
  def destroy
    @portfolio_page = @section.portfolio_pages.find(params[:id])
    @portfolio_page.destroy

    respond_to do |format|
      format.html { redirect_to(admin_portfolio_section_path(@section)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_section
    @section = @site.sections.find(params[:portfolio_section_id])
  end
end
