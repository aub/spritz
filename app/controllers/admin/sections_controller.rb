class Admin::SectionsController < Admin::AdminController

  def index
    @available_section_types = Spritz::Plugin.section_types
    @sections = @site.sections
  end
  
  def create
    section_type = Spritz::Plugin.section_types.find { |st| st.section_name == params[:name] }
    if section_type
      section = section_type.create()
      @site.sections << section
      flash[:notice] = "Successfully created a new section"
      redirect_to admin_sections_path
    else
      flash[:error] = "Failed to create a section"
      redirect_to admin_sections_path
    end
  end
end