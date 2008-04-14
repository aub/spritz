class Admin::LinksController < Admin::AdminController
  
  before_filter :find_section

  # GET /admin/sites/new
  # GET /admin/sites/new.xml
  def new
    @link = @section.links.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @link }
    end
  end

  # GET /admin/sites/1/edit
  def edit
    @link = @section.links.find(params[:id])
  end

  # POST /admin/sites
  # POST /admin/sites.xml
  def create
    @link = @section.links.build(params[:link])

    respond_to do |format|
      if @link.save
        flash[:notice] = 'Link was successfully created.'
        format.html { redirect_to(admin_link_section_path(@section)) }
        format.xml  { render :xml => @link, :status => :created, :location => @link }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @link.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/sites/1
  # PUT /admin/sites/1.xml
  def update
    @link = @section.links.find(params[:id])

    respond_to do |format|
      if @link.update_attributes(params[:link])
        flash[:notice] = 'link was successfully updated.'
        format.html { redirect_to(admin_link_section_path(@section)) }
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
    @link = @section.links.find(params[:id])
    @link.destroy

    respond_to do |format|
      format.html { redirect_to(admin_link_section_path(@section)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_section
    @section = @site.sections.find(params[:link_section_id])
  end
end
