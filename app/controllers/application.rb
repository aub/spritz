class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  before_filter :site_required
  
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
  
  def site_required
    @site = Site.for(request.host, request.subdomains)
    unless @site
      redirect_to new_admin_site_path(:host => MAIN_HOST, :port => request.port)
    end
  end
end
