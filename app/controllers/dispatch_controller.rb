# The dispatch controller implements the fall-through action that will be called
# when no other route handles a given action. It is intended to handle the case 
# where the plugin for a given section does not add its own custom routes to
# handle display of pages on the non-admin side. In particular, it allows for
# pages whose urls do not line up with conditions that are easily mappable. For
# example, we may want the page /Portfolio/Drawings/1 as a URL rather than
# /portfolio_sections/1/portfolio_pages/2/images/1. This method simply loop over
# the set of sections available for the given site, call handle_request on each of
# them if it is implemented, and then return 404 if none of them handle it.
class DispatchController < ContentController

  def dispatch
    # check for any bad urls like /foo//bar
    render_not_found and return if params[:path].any? &:blank?
    
    @section = @site.sections.find { |section| section.name == params[:path][0] }
    result = @section.handle_request(request) if @section && @section.respond_to?(:handle_request)
    if result
      result[1].each { |key,value| instance_variable_set("@#{key.to_s}", value) }
      render :template => result[0].to_s
    end
    render_not_found if result.nil?
  end
end