require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/themes/index.html.haml" do
  include Admin::ThemesHelper
  
  before(:each) do
    theme_98 = mock_model(Theme)
    theme_98.stub!(:title).and_return('theme98')
    theme_98.stub!(:version).and_return('theme98')
    theme_98.stub!(:author).and_return('theme98')
    theme_98.stub!(:author_site).and_return('theme98')
    theme_98.stub!(:summary).and_return('theme98')
    theme_98.stub!(:active?).and_return(true)
    
    theme_99 = mock_model(Theme)
    theme_99.stub!(:title).and_return('theme99')
    theme_99.stub!(:version).and_return('theme98')
    theme_99.stub!(:author).and_return('theme98')
    theme_99.stub!(:author_site).and_return('theme98')
    theme_99.stub!(:summary).and_return('theme98')
    theme_99.stub!(:active?).and_return(false)

    site = mock_model(Site)
    site.stub!(:themes).and_return([theme_98, theme_99])
    site.stub!(:theme).and_return(theme_98)
    
    assigns[:site] = site
  end

  it "should render list of themes" do
    render "/admin/themes/index.html.haml"
  end
end

