require File.dirname(__FILE__) + '/../../spec_helper'

describe GoogleAnalytics do
  define_models :google_analytics

  it "should register itself as a liquid tag" do
    Liquid::Template.tags['googleanalytics'].should == GoogleAnalytics
  end

  it "should render something" do
    render_liquid('{% googleanalytics %}').should_not be_empty
  end
  
  it "should include the site's GA code." do
    render_liquid('{% googleanalytics %}').should match(/#{sites(:default).google_analytics_code}/)
  end
  
  it "should render nothing if the site has nil code" do
    sites(:default).update_attribute(:google_analytics_code, nil)
    render_liquid('{% googleanalytics %}').should == ''
  end
  
  it "should render nothing if the site has an empty code" do
    sites(:default).update_attribute(:google_analytics_code, '')
    render_liquid('{% googleanalytics %}').should == ''
  end
end
