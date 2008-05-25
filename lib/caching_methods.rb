# A module of methods that can be used in a controller to implement page
# and action caching for the app. For both cache types, the code uses an after
# filter to create Cache objects, which are added to the database to keep track
# of the pages that have been cached. The usefulness of this is that when an
# object changes, these objects can be used to allow the sweepers to know what
# to expire.
module CachingMethods
  
  def self.included(base)
    base.before_filter :clear_cached_references
    base.extend ClassMethods
  end
  
  module ClassMethods
    def caches_with_references(*actions)
      # Add a sane cache path to the options if there isn't one there already
      options = actions.extract_options!
      actions << options.reverse_merge({ :cache_path => :create_action_cache_path.to_proc })

      caches_action *actions
      after_filter :cache_action_with_references, :only => actions
    end
  end
  
  protected
  
  def cached_references
    @cached_references ||= []
  end
  
  def clear_cached_references
    @cached_references = nil
  end
  
  # Saves a CachedPage for the current request with the current references.  This is called in an 
  # after filter if caches_action_with_references is used.
  def cache_action_with_references
    return unless perform_caching && caching_allowed && !@site.nil?
    CacheItem.for(@site, self.action_cache_path.path, cached_references)
  end
  
  def create_action_cache_path
    File.join(action_cache_root, request.path)
  end
end