class Admin::UsersController < Admin::AdminController  

  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update]

  skip_before_filter :login_required, :only => [:new, :create, :activate, :forgot_password, :reset_password]

  layout :set_layout

  def edit
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'Your password was successfully updated.'
        format.html { redirect_to admin_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.register! if @user.valid?
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    redirect_to admin_users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to admin_users_path
  end

  def destroy
    @user.delete!
    redirect_to admin_users_path
  end

  def purge
    @user.destroy
    redirect_to admin_users_path
  end

  def forgot_password
  end
  
  def reset_password
    if @user = @site.user_by_email(params[:email])
      flash[:notice] = "A temporary login email has been sent to '#{CGI.escapeHTML @user.email}'"
      # @user.reset_token!
      # UserMailer.deliver_forgot_password(@user)
      redirect_to new_admin_session_path
    else
      flash[:error] = "I could not find an account with the email address '#{CGI.escapeHTML params[:email]}'. Did you type it correctly?"
      render :action => 'forgot_password'
    end
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end
  
  def authorized?
    return false unless logged_in?
    return false if ((params[:action] == 'edit' || params[:action] == 'update') && (!current_user.admin && current_user.id != params[:id]))
    true
  end
  
  def set_layout
    return 'simple' if params[:action] == 'forgot_password' || params[:action] == 'reset_password'
    'admin'
  end
end
