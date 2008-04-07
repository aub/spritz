ActionController::Routing::Routes.draw do |map|

  map.overview 'admin', :controller => 'admin/overview', :action => 'show'

  map.namespace(:admin) do |admin|
  	admin.resources :users, :member => { :suspend   => :put,
                                         :unsuspend => :put,
                                         :purge     => :delete,
                                         :activate => :get }
    admin.resource :session
    admin.resources :sites
  end
  
  map.activate 'activate/:activation_code', :controller => 'admin/users', :action => 'activate'
  
end
