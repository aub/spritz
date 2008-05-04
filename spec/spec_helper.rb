ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require 'ruby-debug'
require 'model_stubbing'
require File.join(File.dirname(__FILE__), 'model_stubs')
require File.join(File.dirname(__FILE__), 'custom_matchers')

include AuthenticatedTestHelper

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

# Stub out the site's for method with some value in order to make
# requests use that site.
def activate_site(site)
  if site.nil?
    Site.stub!(:for).and_return(nil)
  elsif site.is_a?(Symbol)
    Site.stub!(:for).and_return(sites(site))
  else
    Site.stub!(:for).and_return(site)
  end
end

# For a given set of actions, test that a site is or is not required.
def test_site_requirement(required, actions)
  login_as(:admin)
  activate_site(nil)
  condition = required ? 
    lambda { response.should redirect_to(new_admin_site_path) } :
    lambda { response.should_not redirect_to(new_admin_site_path) }
  test_action_requirements(actions, condition)
end

# For a given set of actions, test that a user is or is not required or whether they
# are required to be an admin.
def test_login_requirement(required, admin_required, actions)
  activate_site(:default)
  if required && admin_required
    login_as(:nonadmin)
    test_action_requirements(actions, lambda { response.should redirect_to(new_admin_session_path) })
  else
    login_as(nil)
    condition = required ?
      lambda { response.should redirect_to(new_admin_session_path) } :
      lambda { response.should_not redirect_to(new_admin_session_path) }
    test_action_requirements(actions, condition)
  end
end

# Helper method for testing all sorts of conditions for sets of actions. See examples
# of usage above.
def test_action_requirements(actions, condition)
  actions.should_not be_nil
  
  # if it's a hash, the expected format is { :action => :method, etc... }
  if actions.is_a?(Hash)
    actions.keys.each do |key|
      self.send(actions[key], key)
      condition.call
    end 
  elsif actions.is_a?(Array) # otherwise a list of actions, with get assumed.
    actions.each do |action|
      if action.is_a?(Symbol)
        get action
        condition.call
      elsif action.is_a?(Proc)
        action.call
        condition.call
      end
    end
  elsif actions.is_a?(Proc) # If it's a proc, just call it.
    actions.call
    condition.call
  else # Otherwise, just fail
    false.should be_true # lame-o
  end
end

# Helper for mocking liquid contexts
# mocks a Liquid::Context
def mock_context(assigns = {}, registers = {})
  returning Liquid::Context.new(assigns, registers) do |context|
    assigns.keys.each { |k| context[k].context = context }
  end
end

def disable_caching_for_this_spec
  eval(<<-EOF
    before(:all) do
      ActionController::Base.perform_caching = false
    end
  
    after(:all) do
      ActionController::Base.perform_caching = true
    end
    EOF
  )
end

def render_liquid(content, site=nil, params=nil)
  @template = Liquid::Template.parse(content)
  params ||= {}
	@template.render(params.merge({ 'site' => (site.nil? ? sites(:default) : sites(site)) }))
end

Debugger.start