class LinkSweeper < ActionController::Caching::Sweeper
  observe Link
  
  def expire_caches_for(items)
    site.cache_items.find_for_records(items).each { |ci| ci.expire!(controller) }
  end
  
  def after_save(record)
    return if controller.nil?
    expire_caches_for [record]
  end
  
  def after_destroy(record)
    return if controller.nil?
    expire_caches_for [site.links, record]
  end
  
  def after_create(record)
    return if controller.nil?
    expire_caches_for [site.links]
  end
end