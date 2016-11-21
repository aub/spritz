class UserMailer < ActionMailer::Base
  include ActionController::UrlWriter
  @@mail_from = nil
  mattr_accessor :mail_from

  def forgot_password(user)
    setup_email(user)
    @subject += 'Request to change your password'
    @body[:url] = login_from_token_admin_user_url(user.remember_token)
  end

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://YOURSITE/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://YOURSITE/"
  end
  
  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "#{@@mail_from}"
    @subject     = "#{default_url_options[:host]}: "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
