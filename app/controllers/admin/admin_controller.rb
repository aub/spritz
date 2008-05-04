# This controller handles the login/logout function of the site.  
class Admin::AdminController < ApplicationController
  before_filter :login_required
  
  protect_from_forgery
  
  layout 'admin'
  
end