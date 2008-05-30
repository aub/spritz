class CacheItem < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :site_id
  validates_presence_of :path

  # Expiration method. If multi-site is enabled, then we will be doing action caching,
  # and action caching otherwise. The method will expire the action/page against the 
  # given controller and then destroy itself.
  def expire!(controller)
    if Site.multi_sites_enabled
      controller.expire_action(self.path)
    else
      controller.expire_page(self.path)
    end
    self.destroy
  end
  
  class << self
    # Finds all items that refer to the given object. The object should be
    # an active record model, and this can be used to find all of the pages
    # that should be expired when the model changes.
    #
    #   CacheItem.find_for_record  Foo.find(15)
    #   CacheItem.find_for_records Foo.find(15,16,17)
    def find_for_records(records)
      find_by_reference_keys records.collect { |r| reference_key_for(r) }
    end

    def find_for_record(record)
      find_for_records [record]
    end
  
    # Create a cache for the given site, path, and set of references. First, clean up
    # the referenced objects and then create the cache.
    def for(site, path, references)
      returning find_or_initialize_by_site_id_and_path(site.id, path) do |cache|
        references.uniq!
        cache.references = references.collect! { |r| reference_key_for(r) }.join
        cache.save
      end
    end
  
    protected
  
    # Create a key for one referenced object [id:class]. This also handles association proxies
    # so that for something like Site.links it will return [id:Site:links]. This allows us to expire
    # pages correctly when the page asks for the set of links without having to expire every page
    # that references the site itself.
    def reference_key_for(object)
      return nil if object.nil?
  
      if object.kind_of?(ActiveRecord::Base)
        "[#{object.id}:#{object.class}]"
      elsif object.respond_to?(:proxy_owner)
        "[#{object.proxy_owner.id}:#{object.proxy_owner.class}:#{object.proxy_reflection.name}]"
      end
    end
  
    # Finds all items that the given record keys refer to. Use reference_key_for
    # to get the properly formatted keys.
    def find_by_reference_keys(array_of_keys)
      col_name = connection.quote_column_name('references')    
      find :all, :conditions => ["#{array_of_keys.collect { |r| "#{col_name} LIKE ?" } * ' OR '}", *array_of_keys.collect { |r| "%#{r}%" }]
    end
  end
end