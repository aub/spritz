class SectionSweeper < ActionController::Caching::Sweeper

  observe Section
  
  # If we're doing an update, then we can just expire the pages that are related to the
  # section itself.  
  def after_save(entry)
    site.cache_items.find_for_record(entry).each { |ci| ci.expire!(controller) } unless site.nil? || controller.nil?
  end
  
  # If we're destroying it, we have to expire the pages for the section and the site that
  # contains it.
  def after_destroy(entry)
    site.cache_items.find_for_records([entry, site]).each { |ci| ci.expire!(controller) } unless site.nil? || controller.nil?
  end
  
  # If we're creating it, we have to expire the pages for the site that contains it.
  def after_create(entry)
    site.cache_items.find_for_record(site).each { |ci| ci.expire!(controller) } unless site.nil? || controller.nil?
  end  
end