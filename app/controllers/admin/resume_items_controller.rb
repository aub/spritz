class Admin::ResumeItemsController < Admin::AdminController

  before_filter :find_resume_section

  # GET /admin/resume_sections/1/resume_items.xml
  def index
    @resume_items = @resume_section.resume_items
    respond_to do |format|
      format.xml { render :xml => @resume_items }
    end
  end
  
  # GET /admin/resume_sections/1/resume_items/1.xml
  def show
    @resume_item = @resume_section.resume_items.find(params[:id])
    respond_to do |format|
      format.xml { render :xml => @resume_item }
    end
  end

  # GET /admin/resume_sections/1/resume_items/new
  # GET /admin/resume_sections/1/resume_items/new.xml
  def new
    @resume_item = @resume_section.resume_items.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resume_item }
    end
  end

  # GET /admin/resume_sections/1/resume_items/1/edit
  def edit
    @resume_item = @resume_section.resume_items.find(params[:id])
  end

  # POST /admin/resume_sections/1/resume_items
  # POST /admin/resume_sections/1/resume_items.xml
  def create
    @resume_item = @resume_section.resume_items.create(params[:resume_item])
    respond_to do |format|
      if @resume_item.save
        flash[:notice] = 'The item was successfully created.'
        format.html { redirect_to edit_admin_resume_section_path(@resume_section) }
        format.xml  { render :xml => @resume_item, :status => :created, :location => @resume_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resume_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/resume_sections/1/resume_items/1
  # PUT /admin/resume_sections/1/resume_items/1.xml
  def update
    @resume_item = @resume_section.resume_items.find(params[:id])
    respond_to do |format|
      if @resume_item.update_attributes(params[:resume_item])
        flash[:notice] = 'The item was successfully updated.'
        format.html { redirect_to edit_admin_resume_section_path(@resume_section) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resume_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/resume_sections/1/resume_items/reorder
  def reorder
    @resume_section.resume_items.reorder! params[:resume_items]
    render :nothing => true
  end

  # DELETE /admin/resume_sections/1/resume_items/1
  # DELETE /admin/resume_sections/1/resume_items/1.xml
  def destroy
    @resume_item = @resume_section.resume_items.find(params[:id])
    @resume_item.destroy
    respond_to do |format|
      format.html { redirect_to(edit_admin_resume_section_path(@resume_section)) }
      format.xml  { head :ok }
    end
  end
  
  protected
  
  def find_resume_section
    @resume_section = @site.resume_sections.find(params[:resume_section_id])
  end
end
