class Admin::SectionsController < Admin::AdminController

  cache_sweeper :section_sweeper, :only => [:create]

  def index
    @available_section_types = Spritz::Plugin.section_types
    @sections = @site.sections
  end
  
  def create
    section_type = Spritz::Plugin.section_types.find { |st| st.section_name == params[:name] }
    @section = section_type.new(:site_id => @site.id, :title => "#{section_type}-#{@site.sections.size + 1}") unless section_type.nil?
    
    if (@section && @section.save)
      flash[:notice] = "Successfully created a new section"
      redirect_to admin_sections_path
    else
      flash[:error] = "Failed to create a section"
      redirect_to admin_sections_path
    end
  end
end