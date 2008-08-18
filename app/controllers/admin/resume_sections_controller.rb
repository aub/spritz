class Admin::ResumeSectionsController < Admin::AdminController

  cache_sweeper :resume_section_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /admin/resume_sections
  def index
    @resume_sections = @site.resume_sections
  end

  # GET /admin/resume_sections/new
  def new
    @resume_section = @site.resume_sections.build
  end

  # GET /admin/resume_sections/1/edit
  def edit
    @resume_section = @site.resume_sections.find(params[:id])
  end

  # POST /admin/resume_sections
  def create
    @resume_section = @site.resume_sections.create(params[:resume_section].reverse_merge({ :position => @site.last_resume_section_position + 1 }))
    if @resume_section.valid?
      flash[:notice] = "#{@resume_section.title} was successfully created."
      redirect_to edit_admin_resume_section_path(@resume_section)
    else
      render :action => "new"
    end
  end

  # PUT /admin/resume_sections/1
  def update
    @resume_section = @site.resume_sections.find(params[:id])
    if @resume_section.update_attributes(params[:resume_section])
      flash[:notice] = "#{@resume_section.title} was successfully updated."
      redirect_to admin_resume_sections_path
    else
      render :action => "edit"
    end
  end

  # PUT /links/reorder
  def reorder
    @site.resume_sections.reorder! params[:resume_sections]
    render :nothing => true
  end

  # DELETE /admin/resume_sections/1
  def destroy
    @resume_section = @site.resume_sections.find(params[:id])
    @resume_section.destroy
    redirect_to(admin_resume_sections_url)
  end
end
