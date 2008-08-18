class Admin::UsersController < Admin::AdminController  

  # Protect these actions behind an admin login
  before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge, :index, :create, :new]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge, :edit, :update]

  before_filter :set_mailer_host, :only => [:reset_password]

  skip_before_filter :login_required, :only => [:activate, :forgot_password, :reset_password, :login_from_token]

  layout :set_layout

  def index
    @users = User.find(:all, :order => 'login')
  end

  def edit
    @sites = Site.find(:all, :order => 'title')
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user.update_attributes(params[:user])
    set_admin(params[:user])
    if @user.valid?
      flash[:notice] = "#{@user.login} was successfully updated."
      redirect_to admin_users_path
    else
      render :action => "edit"
    end
  end

  def new
    @user = User.new
    @sites = Site.find(:all, :order => 'title')
  end

  def create
    @user = User.create(params[:user])
    set_admin(params[:user])
    if @user.valid?
      flash[:notice] = "#{@user.login} was successfully created."
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = 'Signup complete!'
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
      @user.remember_me
      UserMailer.deliver_forgot_password(@user)
      redirect_to new_admin_session_path
    else
      flash[:error] = "There is no account with the email address '#{CGI.escapeHTML params[:email]}'. Did you type it correctly?"
      render :action => 'forgot_password'
    end
  end

  def login_from_token
    self.current_user = User.find_by_remember_token(@site, params[:id])
    if logged_in?
      current_user.forget_me # This is just to cause the token to change so this login won't be valid any longer.
      redirect_to edit_admin_user_path(current_user)
    else
      flash[:error] = "This login is invalid. Try resending your forgotten password request."
      redirect_to new_admin_session_path
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
  
  def set_mailer_host
    UserMailer.default_url_options[:host] = request.host_with_port
  end
  
  def set_admin(user_params)
    @user.update_attribute(:admin, user_params[:admin]) unless user_params[:admin].blank?
  end
end
