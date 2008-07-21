class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include CachingMethods
  include ExceptionNotifiable

  attr_reader :site

  before_filter :site_required
  before_filter :setup_cache_paths
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '5ab8dc88fe7761f4e8c2286255a2666e'  

  # Support custom domains by modifying each cookie to point to the given domain.
  def set_cookie_domain(domain)
    cookies = session.instance_eval("@dbprot" )
    unless cookies.blank?
      cookies.each do |cookie|
        options = cookie.instance_eval("@cookie_options" )
        options["domain"] = domain unless options.blank?
      end
    end
  end
  
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
    if @site
      # Set cookies to the correct domain to support custom domains.
      if request.host == @site.domain
        set_cookie_domain(@site.domain)
      end
    else
      redirect_to new_admin_site_path(:host => MAIN_HOST, :port => request.port)
    end
  end

  # Setup the cache directories for the given request based on the active site.
  def setup_cache_paths
    unless @site.nil?
      self.class.page_cache_directory = @site.page_cache_path.to_s
    end
  end
  
  # Helper methods for error conditions
  
  rescue_from ActiveRecord::RecordNotFound,        :with => :render_not_found
  rescue_from ActionController::UnknownController, :with => :render_not_found
  rescue_from ActionController::UnknownAction,     :with => :render_not_found

  def render_not_found
    render :file => File.join(RAILS_ROOT, 'public/404.html'), :status => :not_found
  end  
end
