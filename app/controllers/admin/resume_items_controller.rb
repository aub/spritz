class Admin::ResumeItemsController < Admin::AdminController

  before_filter :find_resume_section

  cache_sweeper :resume_item_sweeper, :only => [:create, :update, :reorder, :destroy]

  # GET /admin/resume_sections/1/resume_items/new
  def new
    @resume_item = @resume_section.resume_items.build
  end

  # GET /admin/resume_sections/1/resume_items/1/edit
  def edit
    @resume_item = @resume_section.resume_items.find(params[:id])
  end

  # POST /admin/resume_sections/1/resume_items
  def create
    @resume_item = @resume_section.resume_items.create(params[:resume_item])
    if @resume_item.valid?
      flash[:notice] = 'The item was successfully created.'
      redirect_to edit_admin_resume_section_path(@resume_section)
    else
      render :action => "new"
    end
  end

  # PUT /admin/resume_sections/1/resume_items/1
  def update
    @resume_item = @resume_section.resume_items.find(params[:id])
    if @resume_item.update_attributes(params[:resume_item])
      flash[:notice] = 'The item was successfully updated.'
      redirect_to edit_admin_resume_section_path(@resume_section)
    else
      render :action => "edit"
    end
  end

  # PUT /admin/resume_sections/1/resume_items/reorder
  def reorder
    @resume_section.resume_items.reorder! params[:resume_items]
    render :nothing => true
  end

  # DELETE /admin/resume_sections/1/resume_items/1
  def destroy
    @resume_item = @resume_section.resume_items.find(params[:id])
    @resume_item.destroy
    redirect_to(edit_admin_resume_section_path(@resume_section))
  end
  
  protected
  
  def find_resume_section
    @resume_section = @site.resume_sections.find(params[:resume_section_id])
  end
end
