class ContactController < ContentController

  caches_with_references :new
  
  # GET /contact/new
  def new
    render :template => 'contact'
  end
  
  # POST /contact
  def create
    @contact = @site.contacts.create(params[:contact])
    respond_to do |format|
      if @contact.save
        @message = 'Thank you for the message.'
        ContactMailer.deliver_new_contact(User.find_all_by_site(@site).first, @contact)
      end
      format.html { render :template => 'contact' }
    end
  end
end
