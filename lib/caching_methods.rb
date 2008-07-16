# A module of methods that can be used in a controller to implement page
# and action caching for the app. For both cache types, the code uses an after
# filter to create Cache objects, which are added to the database to keep track
# of the pages that have been cached. The usefulness of this is that when an
# object changes, these objects can be used to allow the sweepers to know what
# to expire. When multi-site is enabled, we are forced to use action caching
# in order to apply the before_filter that sets up the appropriate site object.
# When it is disabled, page caching will suffice because we can't use the wrong
# cached page.
module CachingMethods
  
  def self.included(base)
    base.before_filter :clear_cached_references
    base.extend ClassMethods
  end
  
  module ClassMethods
    def caches_with_references(*actions)
      caches_page *actions
      after_filter :cache_with_references, :only => actions
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
  # after filter if caches_action_with_references is used. The path to use depends on whether
  # multi-site is enabled of not. If it is disabled, we can just use the path from the request.
  # When enabled, we have to cache the data for the different sites in different locations, so
  # it is necessary to compute a path based on the data in the site.
  def cache_with_references
    return unless perform_caching && caching_allowed && !@site.nil?
    CacheItem.for(@site, request.path, cached_references)
  end
  
  def create_action_cache_path
    File.join(action_cache_root, request.path)
  end
end