class ResumeItemSweeper < ActionController::Caching::Sweeper
  observe ResumeItem
  
  def expire_caches_for(items)
    site.cache_items.find_for_records(items).each { |ci| ci.expire!(controller) }
  end
  
  def after_save(record)
    return if controller.nil?
    expire_caches_for [record]
  end
  
  def after_destroy(record)
    return if controller.nil?
    expire_caches_for [record.resume_section.resume_items, record]
  end
  
  def after_create(record)
    return if controller.nil?
    expire_caches_for [record.resume_section.resume_items]
  end
end