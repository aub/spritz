# class RequireSite
#   
#   def initialize(redirect_path)
#     
#   end
# 
#   def matches?(target)
#     activate_site nil
#     response = target.call
#     debugger
#     return response.redirect? && response.redirect_url == new_admin_site_path
#   end
# 
#   def failure_message
#     "expected a site to be required"
#   end
# 
#   def negative_failure_message
#     "expected no site to be required"
#   end
# 
#   def description
#     "require site"
#   end
# 
# end
# 
# def require_site
#   RequireSite.new
# end