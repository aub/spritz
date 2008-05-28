class Admin::ResumeSectionsController < Admin::AdminController

  # GET /admin/resume_sections
  # GET /admin/resume_sections.xml
  def index
    @resume_sections = @site.resume_sections
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resume_sections }
    end
  end

  # GET /admin/resume_sections/new
  # GET /admin/resume_sections/new.xml
  def new
    @resume_section = @site.resume_sections.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume_section }
    end
  end

  # GET /admin/resume_sections/1/edit
  def edit
    @resume_section = @site.resume_sections.find(params[:id])
  end

  # POST /admin/resume_sections
  # POST /admin/resume_sections.xml
  def create
    @resume_section = @site.resume_sections.create(params[:resume_section].reverse_merge({ :position => @site.last_resume_section_position + 1 }))
    respond_to do |format|
      if @resume_section.valid?
        flash[:notice] = "#{@resume_section.title} was successfully created."
        format.html { redirect_to edit_admin_resume_section_path(@resume_section) }
        format.xml  { render :xml => @resume_section, :status => :created, :location => @resume_section }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resume_section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/resume_sections/1
  # PUT /admin/resume_sections/1.xml
  def update
    @resume_section = @site.resume_sections.find(params[:id])
    respond_to do |format|
      if @resume_section.update_attributes(params[:resume_section])
        flash[:notice] = "#{@resume_section.title} was successfully updated."
        format.html { redirect_to admin_resume_sections_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume_section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /links/reorder
  def reorder
    @site.resume_sections.reorder! params[:resume_sections]
    render :nothing => true
  end

  # DELETE /admin/resume_sections/1
  # DELETE /admin/resume_sections/1.xml
  def destroy
    @resume_section = @site.resume_sections.find(params[:id])
    @resume_section.destroy
    respond_to do |format|
      format.html { redirect_to(admin_resume_sections_url) }
      format.xml  { head :ok }
    end
  end
end
