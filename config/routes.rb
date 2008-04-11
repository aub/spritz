ActionController::Routing::Routes.draw do |map|

  # Routes for accessing the resources for use in the theme. Note that we need to include
  # 'theme' here to differentiate them from the standard files.
  map.with_options(:controller => 'theme', :conditions => {:method => :get}) do |theme|
    theme.connect 'stylesheets/theme/:filename.:ext', :action => 'stylesheets'
    theme.connect 'javascripts/theme/:filename.:ext', :action => 'javascripts'
    theme.connect 'images/theme/:filename.:ext',      :action => 'images'
  end

  # Routes for the admin interface.
  map.dashboard 'admin', :controller => 'admin/dashboard', :action => 'show'

  map.namespace(:admin) do |admin|
  	admin.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete, :activate => :get }
    admin.resource :session
    admin.resources :sites
    admin.resource :settings
  end
  
  # A route to handle activation of users.
  map.activate 'activate/:activation_code', :controller => 'admin/users', :action => 'activate'
  
  # And the routes for the generated content of the various pages.
  map.home '', :controller => 'home', :action => 'show'
  
end
