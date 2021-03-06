# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Set the caching directories. If I use tmp/cache, rails will create a file store there
# from thereafter, hijacking whatever I set up, so this is just to make sure we avoid
# using that directory.
ActionController::Base.cache_store          = :file_store, File.join(RAILS_ROOT, 'tmp/caches')

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# This is the address where the query will get redirected to when hitting a location
# where there is no valid site.
MAIN_HOST = 'localhost:3000'

# This is the directory where the themes will be stored.
THEME_PATH_ROOT = 'themes'

# Enable if you want to host multiple sites on this app
# Spritz.multi_sites_enabled = true
