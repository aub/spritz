class AssetSweeper < ActionController::Caching::Sweeper
  observe Asset
    
  def after_save(entry)
    entry.site.cache_items.find_for_records(entry.assigned_assets).each { |ci| ci.expire!(controller) }
  end
  
  # alias_method :after_destroy, :expire_cached_content
  
  # Don't need to expire anything when it is created.
  # alias_method :after_create, :expire_cached_content
end