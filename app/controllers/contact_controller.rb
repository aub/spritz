class ContactController < ContentController
  
  # GET /contact/new
  def new
    render :template => 'contact'
  end
  
  # POST /contact
  def create
    @contact = @site.contacts.create(params[:contact])
    respond_to do |format|
      @message = 'Thank you for the message.' if @contact.save        
      format.html { render :action => 'new' }
    end
  end
end
