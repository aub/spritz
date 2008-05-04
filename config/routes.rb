ActionController::Routing::Routes.draw do |map|
  map.resources :contacts

  # Routes for accessing the resources for use in the theme. Note that we need to include
  # 'theme' here to differentiate them from the standard files.
  map.with_options(:controller => 'theme', :conditions => {:method => :get}) do |theme|
    theme.connect 'theme/stylesheets/:filename.:ext', :action => 'stylesheets'
    theme.connect 'theme/javascripts/:filename.:ext', :action => 'javascripts'
    theme.connect 'theme/images/:filename.:ext',      :action => 'images'
  end

  # Routes for the admin interface.
  map.dashboard 'admin', :controller => 'admin/dashboard', :action => 'show'

  map.namespace(:admin) do |admin|
    admin.resources :assets
    admin.resources :contacts
    admin.resources :links
    admin.resources :news_items
    admin.resources :portfolios, :member => { :add_child => :get } do |portfolios|
      portfolios.resources :assigned_assets
    end
    admin.resources :sections
    admin.resource :session
    admin.resource :settings
    admin.resources :sites
    admin.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete, :activate => :get }
  end

  # Routes for the display interface
  map.home '', :controller => 'home', :action => 'show'

  map.resource :contact, :controller => 'contact'
  map.resources :links
  map.resources :news_items
  map.resources :portfolios do |portfolios|
    portfolios.resources :items
  end
  
  # A route to handle activation of users.
  map.activate 'activate/:activation_code', :controller => 'admin/users', :action => 'activate'

end
