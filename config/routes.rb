ActionController::Routing::Routes.draw do |map|

  map.namespace(:admin) do |admin|
  	admin.resources :users, :member => { :suspend   => :put,
                                       :unsuspend => :put,
                                       :purge     => :delete,
                                       :activate => :get }
    admin.resource :session
  end
  
  map.activate 'activate/:activation_code', :controller => 'admin/users', :action => 'activate'
  
end
