# require 'uri'
# 
# module CachingExampleHelper
# 
#   # For testing caching, remove the entire cache directory and then execute
#   # the request. Now you can use cached? below to make sure the file was
#   # created.
#   def action(&request)
#     cache_dir = ActionController::Base.cache_store.cache_path
#     FileUtils.rm_rf(cache_dir)
#     request.call
#   end
#   
#   module ResponseHelper
#     def cached?
#       cache_path = ActionController::Base.cache_store.cache_path
#       path = (request.path.empty? || request.path == "/") ? "/index" : URI.unescape(path.chomp('/'))
#       site = Site.for(request.domain)
#       cache_file = File.join(cache_path, site.domain, path + '.cache')
# 
#       File.exists? cache_file
#     end
#   end
# 
#   ActionController::TestResponse.send(:include, ResponseHelper)
# end

class CacheAction
  @@cache_dir = ActionController::Base.cache_store.cache_path
  
  def initialize(controller)
    @controller = controller
  end

  def trash_cache    
    FileUtils.rm_rf(@@cache_dir)
  end

  def matches?(target)
    trash_cache
    target.call
    result = File.exists?(File.join(@@cache_dir, @controller.action_cache_path.path + '.cache'))
    trash_cache
    result
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

def cache_action
  CacheAction.new(controller)
end


class ExpireAction
  @@cache_dir = ActionController::Base.cache_store.cache_path
  
  def initialize(action, controller)
    @action = action
    @controller = controller
  end

  def matches?(target)
    action.call
    there_before = File.exists?(File.join(@@cache_dir, @controller.action_cache_path.path + '.cache'))

    target.call
    there_now = File.exists?(File.join(@@cache_dir, @controller.action_cache_path.path + '.cache'))
    
    there_before && !there_now
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

def expire_action(action)
  ExpireAction.new(action, controller)
end


class Expire
  def initialize(expired_cache_items)
    @expired_cache_items = expired_cache_items
  end

  def matches?(target)
    prev_items = CacheItem.find(:all)

    response = target.call
    after_items = CacheItem.find(:all)
    
    value = !@expired_cache_items.any? { |item| after_items.include?(item) } 
    value &&= (after_items == prev_items - @expired_cache_items)
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

def expire(expired_cache_items)
  Expire.new(expired_cache_items)
end
