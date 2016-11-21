class ResumeSectionSweeper < ActionController::Caching::Sweeper
  observe ResumeSection
  
  def expire_caches_for(items)
    site.cache_items.find_for_records(items).each { |ci| ci.expire!(controller) }
  end
  
  def after_save(record)
    return if controller.nil?
    expire_caches_for [record]
  end
  
  def after_destroy(record)
    return if controller.nil?
    expire_caches_for [site.resume_sections, record]
  end
  
  def after_create(record)
    return if controller.nil?
    expire_caches_for [site.resume_sections]
  end
end