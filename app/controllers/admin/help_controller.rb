class Admin::HelpController < Admin::AdminController
  
  def show
    render :template => "admin/help/#{params[:page]}"
  end
  
end