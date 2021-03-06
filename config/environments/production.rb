# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# This is the address where the query will get redirected to when hitting a location
# where there is no valid site.
MAIN_HOST = '127.0.0.1'

# This is the directory where the themes will be stored.
THEME_PATH_ROOT = 'themes'

# Enable if you want to host multiple sites on this app
# Spritz.multi_sites_enabled = true
