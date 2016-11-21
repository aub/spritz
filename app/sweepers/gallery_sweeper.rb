class GallerySweeper < ActionController::Caching::Sweeper
  observe Gallery
  
  def expire_caches_for(items)
    site.cache_items.find_for_records(items).each { |ci| ci.expire!(controller) }
  end
  
  def after_save(record)
    return if controller.nil?
    expire_caches_for [record]
  end
  
  def after_destroy(record)
    return if controller.nil?
    expire_caches_for [site.galleries, record]
  end
  
  def after_create(record)
    return if controller.nil?
    expire_caches_for [site.galleries]
  end
end