class ContactMailer < ActionMailer::Base
  include ActionController::UrlWriter
  @@mail_from = nil
  mattr_accessor :mail_from
  
  def new_contact(user, contact)
    setup_email(user, contact)
    @subject += 'New contact'
  end
  
  protected

  def setup_email(user, contact)
    @recipients     = "#{user.email}"
    @from           = "#{@@mail_from}"
    @subject        = "#{default_url_options[:host]}: "
    @sent_on        = Time.now
    @body[:user]    = user
    @body[:contact] = contact
  end
end