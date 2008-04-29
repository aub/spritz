require File.dirname(__FILE__) + '/../../spec_helper'

describe UrlFilters do
  include UrlFilters
  
  define_models :url_filters do
    model Section do
      stub :one, :title => 'heya'
    end
  end
  
  it "should description" do
    link_to_section(sections(:one).to_liquid).should == '<a href="">heya</a>'
  end
end
