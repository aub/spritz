require 'uri'

module CachingExampleHelper
  ActionController::Base.public_class_method :page_cache_path
  ActionController::Base.perform_caching = true

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

# 
# class CacheAction
#   
#   def initialize(location)
#     @location = location
#   end
# 
#   def matches?(target)
#     FileUtils.rm(@location) if File.exist?(@location)
#     response = target.call
#     File.exist?(@location)
#   end
# 
#   def failure_message
#     "expected a file to have been cached at #{@location}"
#   end
# 
#   def negative_failure_message
#     "expected no file to be cached at #{@location}"
#   end
# 
#   def description
#     "cache a file"
#   end
# 
# end
# 
# def cache_action(location)
#   CacheAction.new(location)
# end
