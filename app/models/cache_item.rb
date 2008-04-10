class CacheItem < ActiveRecord::Base
  
  belongs_to :site
  
  validates_presence_of :site_id
  validates_presence_of :path

  # Expiration method. Currently assumes that this is an action cache,
  # but should later be expanded to include page caching. The method will
  # expire the action against the given controller and then destroy itself.
  def expire!(controller)
    controller.expire_action(self.path)
    self.destroy
  end
  
  class << self
    # Finds all items that refer to the given object. The object should be
    # an active record model, and this can be used to find all of the pages
    # that should be expired when the model changes.
    #
    #   CachedPage.find_for_record  Foo.find(15)
    #   CachedPage.find_for_rerords *Foo.find(15,16,17)
    def find_for_records(*records)
      find_by_reference_keys *records.collect { |r| reference_key_for(r) }
    end
    alias find_for_record find_for_records
  
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
  
    # Create a key for one referenced object [id,class]
    def reference_key_for(object)
      result = "[#{object.id}:#{object.class}]" unless object.nil?
    end
  
    # Finds all items that the given record keys refer to. Use reference_key_for
    # to get the properly formatted keys.
    def find_by_reference_keys(*array_of_keys)
      col_name = connection.quote_column_name('references')    
      find :all, :conditions => ["#{array_of_keys.collect { |r| "#{col_name} LIKE ?" } * ' OR '}", *array_of_keys.collect { |r| "%#{r}%" }]
    end
  end
end