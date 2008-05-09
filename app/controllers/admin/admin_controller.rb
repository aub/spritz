# This controller handles the login/logout function of the site.  
class Admin::AdminController < ApplicationController
  before_filter :login_required
  
  # This seems to block ajax calls... need to look into it some more.
  # protect_from_forgery
  
  layout 'admin'
  
end