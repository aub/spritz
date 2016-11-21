class PortfolioSweeper < ActionController::Caching::Sweeper
  observe Portfolio
  
  def expire_caches_for(items)
    site.cache_items.find_for_records(items.compact).each { |ci| ci.expire!(controller) }
  end
  
  def after_save(record)
    return if controller.nil?
    expire_caches_for [record, record.parent]
  end
  
  def after_destroy(record)
    return if controller.nil?
    expire_caches_for [record.parent || site.root_portfolios, record]
  end
  
  def after_create(record)
    return if controller.nil?
    if record.parent_id.nil?
      expire_caches_for [site.root_portfolios]
    else
      expire_caches_for [record.parent]
    end
  end
end