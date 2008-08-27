class AssignedAssetSweeper < ActionController::Caching::Sweeper
  observe AssignedAsset
  
  def after_create(record)
    return if controller.nil?
    site.cache_items.find_for_record(record.portfolio).each { |ci| ci.expire!(controller) }
  end
  
  def expire_for_record(record)
    return if controller.nil?
    site.cache_items.find_for_record(record).each { |ci| ci.expire!(controller) }
  end

  alias_method :after_save, :expire_for_record
  alias_method :after_destroy, :expire_for_record  
end