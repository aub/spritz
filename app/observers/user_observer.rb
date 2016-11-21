class UserObserver < ActiveRecord::Observer
  def after_create(user)
    # I'm commenting this out because the users will now start out activated, until the user
    # management system becomes useful, at least.
    # UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)  
    # Ditto above...
    # UserMailer.deliver_activation(user) if user.pending?
  end
end
