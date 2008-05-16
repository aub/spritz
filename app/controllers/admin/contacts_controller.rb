class Admin::ContactsController < Admin::AdminController
  # GET /admin/contacts
  # GET /admin/contacts.xml
  def index
    @contacts = @site.contacts
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contacts }
    end
  end

  # GET /admin/contacts/1
  # GET /admin/contacts/1.xml
  def show
    @contact = @site.contacts.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @contact }
    end
  end

  # DELETE /admin/contacts/1
  # DELETE /admin/contacts/1.xml
  def destroy
    @contact = @site.contacts.find(params[:id])
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to(admin_contacts_path) }
      format.xml  { head :ok }
    end
  end
end
