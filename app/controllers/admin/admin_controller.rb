# This controller handles the login/logout function of the site.  
class Admin::AdminController < ApplicationController
  before_filter :login_required
  
  layout 'admin'
  
end