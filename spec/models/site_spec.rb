require File.dirname(__FILE__) + '/../spec_helper'

describe Site do
  before(:each) do
    @site = Site.new
  end

  it "should be valid" do
    @site.should be_valid
  end

  describe "accessing the site for a domain and subdomain" do
    define_models :site
    
    it "should return the correct site for a given domain" do
      Site.for(sites(:default).domain, []).should == sites(:default)
    end
    
    it "should return the correct site for a given subdomain" do
      Site.for('blah', [sites(:default).subdomain]).should == sites(:default)
    end
    
    it "should return nil for no match" do
      Site.for('blah', []).should be_nil
    end
  end
end
