require "#{File.dirname(__FILE__)}/../test_helper"
require "relevance/tarantula"

class TarantulaTest < ActionController::IntegrationTest
  fixtures :all

  def test_tarantula
    post '/admin/session', :login => 'quentin', :password => 'test'
    assert_response :redirect
    follow_redirect!
    t = tarantula_crawler(self)
    t.handlers << Relevance::Tarantula::TidyHandler.new
    t.crawl '/admin'
  end
end
