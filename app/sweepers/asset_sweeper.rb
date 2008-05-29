class AssetSweeper < ActionController::Caching::Sweeper
  observe Asset
  
  # This is necessary because while the fields are on the asset, it's the assigned asset whose
  # drop we create.
  def after_save(entry)
    return if controller.nil?
    site.cache_items.find_for_records(entry.assigned_assets).each { |ci| ci.expire!(controller) }
  end

  # When the asset is destroyed, its assigned assets will automatically be destroyed as well,
  # so there is no need to do this.
  # alias_method :after_destroy, :expire_cached_content
  
  # Don't need to expire anything when it is created.
  # alias_method :after_create, :expire_cached_content
end