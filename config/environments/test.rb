# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports
config.action_controller.consider_all_requests_local = true

# Cache settings
config.action_controller.perform_caching             = true
config.action_controller.page_cache_directory        = File.join(RAILS_ROOT, 'tmp/test/caches')
ActionController::Base.fragment_cache_store          = :file_store, File.join(RAILS_ROOT, 'tmp/test/caches')

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell ActionMailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

# This is the address where the query will get redirected to when hitting a location
# where there is no valid site.
MAIN_HOST = 'test.host'

# This is the root of the directory under which the asset files will be stored for file-system
# storage.
ASSET_PATH_ROOT = 'tmp/test/assets'

# This is the directory where the themes will be stored.
THEME_PATH_ROOT = 'tmp/test/themes'

# Enable if you want to host multiple sites on this app
# Spritz.multi_sites_enabled = true