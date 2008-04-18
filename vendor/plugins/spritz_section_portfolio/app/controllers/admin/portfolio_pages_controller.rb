class Admin::PortfolioPagesController < Admin::AdminController
  
  before_filter :find_section
  before_filter :find_portfolio_page, :only => [ :destroy, :edit, :update, :new ]

  # GET /admin/sites/new
  # GET /admin/sites/new.xml
  def new
    @parent = @portfolio_page
    @portfolio_page = @section.portfolio_pages.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portfolio_page }
    end
  end

  # GET /admin/sites/1/edit
  def edit
  end

  # POST /admin/sites
  # POST /admin/sites.xml
  def create
    parent_id = params.delete :id
    @portfolio_page = @section.portfolio_pages.build(params[:portfolio_page])
    respond_to do |format|
      if @portfolio_page.save
        flash[:notice] = "\"#{@portfolio_page.name}\" was successfully created."
        parent = parent_id.nil? ? @section.portfolio : @section.portfolio_pages.find(parent_id)
        @portfolio_page.move_to_child_of(parent)
        format.html { redirect_to(edit_admin_portfolio_section_portfolio_page_path(@section, @portfolio_page)) }
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
    respond_to do |format|
      if @portfolio_page.update_attributes(params[:portfolio_page])
        flash[:notice] = 'portfolio page was successfully updated.'
        format.html { redirect_to(edit_admin_portfolio_section_portfolio_page_path(@section, @portfolio_page)) }
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
    @portfolio_page.destroy
    respond_to do |format|
      format.html { redirect_to(admin_portfolio_section_path(@section)) }
      format.xml  { head :ok }
    end
  end
  
  protected

  def find_portfolio_page
    @portfolio_page = @section.portfolio_pages.find(params[:id])
  end
  
  def find_section
    @section = @site.sections.find(params[:portfolio_section_id])
  end
end
