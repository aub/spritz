class ContactController < ContentController
  
  # GET /contact/new
  def new
    render :template => 'contact'
  end
  
  # POST /contact
  def create
    @contact = @site.contacts.create(params[:contact])
    respond_to do |format|
      if @contact.save
        flash[:notice] = 'Contact was successfully created.'
        format.html { redirect_to home_path }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
end
