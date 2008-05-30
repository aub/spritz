# This controller handles the login/logout function of the site.  
class Admin::AdminController < ApplicationController
  before_filter :login_required
  
  # This seems to block ajax calls... need to look into it some more.
  # protect_from_forgery
  
  layout 'admin'
  
  protected
  
  def expire_home_page
    cache = @site.cache_items.find_by_path('/')
    cache.expire!(self) unless cache.nil?
  end
  
end