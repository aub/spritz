require File.dirname(__FILE__) + '/../../../spec_helper'

describe "/admin/themes/index.html.haml" do
  include Admin::ThemesHelper
  
  before(:each) do
    theme_98 = mock_model(Theme)
    theme_99 = mock_model(Theme)

    assigns[:themes] = [theme_98, theme_99]
  end

  it "should render list of themes" do
    render "/admin/themes/index.html.haml"
  end
end

