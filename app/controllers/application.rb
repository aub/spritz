class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include CachingMethods

  attr_reader :site
  attr_reader :action_cache_directory

  before_filter :site_required
  before_filter :setup_cache_paths
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5ab8dc88fe7761f4e8c2286255a2666e'  
  
  protected
  
  helper_method :admin?
  
  def admin?
    logged_in? && current_user.admin?
  end
  
  def admin_required
    redirect_to new_admin_session_path unless admin?
  end
  
  # Make sure that there is a valid site for the given request, or bounce it
  # to the site creation page.
  def site_required
    @site = Site.for(request.host, request.subdomains)
    unless @site
      redirect_to new_admin_site_path(:host => MAIN_HOST, :port => request.port)
    end
  end

  # Setup the cache directories for the given request based on the active site.
  def setup_cache_paths
    @action_cache_path = @site.action_cache_path unless @site.nil?
  end
  
  # Helper methods for error conditions
  
  rescue_from ActiveRecord::RecordNotFound,        :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  rescue_from ActionController::UnknownAction,     :with => :render_not_found

  def render_not_found
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => :not_found
  end  
end
