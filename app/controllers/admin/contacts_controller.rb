class Admin::ContactsController < Admin::AdminController
  # GET /admin/contacts
  def index
    @contacts = @site.contacts
  end

  # DELETE /admin/contacts/1
  def destroy
    @contact = @site.contacts.find(params[:id])
    @contact.destroy
    redirect_to(admin_contacts_path)
  end
end
