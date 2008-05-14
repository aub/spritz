ActionController::Routing::Routes.draw do |map|

  # Routes for accessing the resources for use in the theme. Note that we need to include
  # 'theme' here to differentiate them from the standard files.
  map.with_options(:controller => 'theme', :conditions => {:method => :get}) do |theme|
    theme.connect 'theme/stylesheets/:filename.:ext', :action => 'stylesheets'
    theme.connect 'theme/javascripts/:filename.:ext', :action => 'javascripts'
    theme.connect 'theme/images/:filename.:ext',      :action => 'images'
  end

  # The default admin route... to show the dashboard.
  map.admin 'admin', :controller => 'admin/dashboard', :action => 'show'

  # Routes for the admin interface.
  map.namespace(:admin) do |admin|
    admin.resources :assets
    admin.resources :contacts
    admin.resource :dashboard, :controller => 'dashboard'
    admin.resource :home, :controller => 'home' do |home|
      home.resource :home_image, :controller => 'home_image'
    end
    admin.resources :links, :collection => { :reorder => :put }
    admin.resources :news_items, :collection => { :reorder => :put }
    admin.resources :portfolios, :member => { :add_child => :get, :reorder_children => :put }, :collection => { :reorder => :put } do |portfolios|
      portfolios.resources :assigned_assets, :collection => { :select => :post, :deselect => :delete, :clear => :delete, 
                                                              :reorder => :get, :update_order => :put }
    end
    admin.resources :resources
    admin.resources :sections
    admin.resource :session, :controller => 'session'
    admin.resources :sites
    admin.resources :themes, :member => { :activate => :put, :preview => :get } do |themes|
      themes.resources :resources
    end
    admin.resources :users, :member => { :suspend => :put, :unsuspend => :put, :purge => :delete, :activate => :get },
                            :collection => { :forgot_password => :get, :reset_password => :put }
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
