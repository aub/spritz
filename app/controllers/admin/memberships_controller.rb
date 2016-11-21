class Admin::MembershipsController < Admin::AdminController
  
  # Protect all actions behind an admin login
  before_filter :admin_required
  
  before_filter :find_user

  def index
    @memberships = @user.memberships
  end
  
  def new
    @sites = Site.find(:all) - @user.sites
    @membership = @user.memberships.build
  end
  
  def create
    @membership = @user.memberships.create(params[:membership])
    if @membership.valid?
      redirect_to admin_user_memberships_path(@user)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @membership = @user.memberships.find(params[:id])
    @membership.destroy
    redirect_to admin_user_memberships_path(@user)
  end
  
  protected
  
  def find_user
    @user = User.find(params[:user_id])
  end
end