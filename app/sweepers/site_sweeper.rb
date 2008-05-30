class SiteSweeper < ActionController::Caching::Sweeper
  observe Site
  
  def expire_cached_content(record)
    return if controller.nil?
    record.cache_items.find_for_record(record).each { |ci| ci.expire!(controller) }
  end
  
  alias_method :after_save, :expire_cached_content
  alias_method :after_destroy, :expire_cached_content
  
  # Don't need to expire anything when it is created.
  # alias_method :after_create, :expire_cached_content
end