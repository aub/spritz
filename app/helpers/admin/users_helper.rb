module Admin::UsersHelper
  
  def membership_data(user)
    if (user.memberships.empty?)
      result = 'No memberships.'
    else
      result = 'Member of: ' + user.sites.inject([]) { |l,s| l << s.title } * ', '
    end
    result + link_to('update', admin_user_memberships_path(user), :class => 'update_memberships_link')
  end
end