require File.dirname(__FILE__) + '/../../spec_helper'

describe UrlFilters do
  include UrlFilters
  
  define_models :url_filters
  
  describe "stylesheet method" do
    
    it "should produce a correct link" do
      stylesheet('styles.css').should == "<link href=\"theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end
    
    it "should append .css if not given" do
      stylesheet('styles').should == "<link href=\"theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end

    it "should add the media resource" do
      stylesheet('styles', 'all').should == "<link href=\"theme/stylesheets/styles.css\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />"
    end
    
    it "should render correctly through liquid" do
      render_liquid("{{ 'styles' | stylesheet }}").should == "<link href=\"theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end
  end

  describe "javascript method" do
    
    it "should produce a correct link" do
      javascript('scripts.js').should == "<script src=\"theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end
    
    it "should append .js if not given" do
      javascript('scripts').should == "<script src=\"theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end

    it "should render correctly through liquid" do
      render_liquid("{{ 'scripts' | javascript }}").should == "<script src=\"theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end
  end
  
  
end
