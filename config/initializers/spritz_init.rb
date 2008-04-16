require 'action_controller/dispatcher'
require 'liquid/initializer'

# The code in here will be called after each action in development mode. It
# allows us to do some cleanup as the in-memory objects are destroyed.
class ActionController::Dispatcher
  
  # The plugin system caches a set of section types as classes. They will be
  # incorrect after each action in development mode where the classes are loaded
  # with each request. Just clear the cache here, which will allow it to persist
  # in production mode.
  def self.clear_plugin_cache
    Spritz::Plugin.clear_section_type_cache
  end
  
  def cleanup_application_with_local(force = false)
    returning cleanup_application_without_local(force) do
      self.class.clear_plugin_cache
    end
  end
  
  alias_method_chain :cleanup_application, :local
end
