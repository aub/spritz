require 'uri'

module CachingExampleHelper
  ActionController::Base.public_class_method :page_cache_path
  ActionController::Base.perform_caching = true

  # For testing caching, remove the entire cache directory and then execute
  # the request. Now you can use cached? below to make sure the file was
  # created.
  def action(&request)
    ActionController::Base.perform_caching = true
    cache_dir = ActionController::Base.fragment_cache_store.cache_path
    FileUtils.rm_rf(cache_dir)
    request.call
  end
  
  module ResponseHelper
    def cached?
      cache_path = ActionController::Base.fragment_cache_store.cache_path
      path = (request.path.empty? || request.path == "/") ? "/index" : URI.unescape(path.chomp('/'))
      site = Site.for(request.domain, request.subdomains)
      cache_file = File.join(cache_path, site.subdomain, path + '.cache')

      File.exists? cache_file
    end
  end

  ActionController::TestResponse.send(:include, ResponseHelper)
end


class Expire
  
  def initialize(cache_items)
    @cache_items = cache_items
  end

  def matches?(target)
    response = target.call
    
    all_items = CacheItem.find(:all)
    (@cache_items.find { |ci| all_items.include?(ci) } == nil)
  end

  def failure_message
    "expected all cache items to be expired"
  end

  def negative_failure_message
    "expected no cache items to be expired"
  end

  def description
    "expire cache items"
  end

end

def expire(cache_items)
  Expire.new(cache_items)
end
