ModelStubbing.define_models do
  # only put minimal, core models in here if specs require interaction
  # with lots of models
  
  time 2007, 6, 15
  
  model Site do
    stub :domain => 'www.test.com', :subdomain => 'stubby', :theme_path => 'dark', :title => 'Hack Site', 
      :home_text => 'ht', :home_text_html => 'hthtml', :home_news_item_count => 2, :google_analytics_code => 'abc-123'
    stub :other, :domain => 'www.other.com', :subdomain => 'testy', :theme_path => 'light', :title => 'Something Else', 
      :home_text => 'ht', :home_text_html => 'hthtml', :home_news_item_count => 2, :google_analytics_code => 'def-456'
  end
  
  model User do
    stub :admin, :login => 'admin', :email => 'admin@example.com', :remember_token => 'admintoken', :admin => true,
      :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :state => 'active', :created_at => Time.now.utc - 3.days, :activated_at => 3.months.ago.utc, 
      :remember_token_expires_at => 2.weeks.from_now.utc
      
    stub :nonadmin, :login => 'nonadmin', :email => 'nondamin@example.com', :remember_token => 'nonadmintoken', :admin => false,
      :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :state => 'active', :created_at => Time.now.utc - 1.year, :activated_at => 3.days.ago.utc,
      :remember_token_expires_at => 2.weeks.from_now.utc
      
    stub :unactivated, :login => 'unactivated', :email => 'unactivated@example.com', :remember_token => 'unactivatedtoken', :admin => false,
      :salt => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :state => 'pending', :created_at => Time.now.utc - 1.year, :activation_code => 'acode',
      :remember_token_expires_at => 2.weeks.from_now.utc
  end
  
  model Membership do
    stub :admin_on_default, :user => all_stubs(:admin_user), :site => all_stubs(:site)
    stub :admin_on_other, :user => all_stubs(:admin_user), :site => all_stubs(:other_site)
    stub :nonadmin_on_default, :user => all_stubs(:nonadmin_user), :site => all_stubs(:site)
    stub :unactivated_on_default, :user => all_stubs(:unactivated_user), :site => all_stubs(:site)
  end  
end