require File.dirname(__FILE__) + '/../../spec_helper'

describe UrlFilters do
  include UrlFilters
  
  define_models :url_filters
  
  describe "stylesheet method" do
    define_models :url_filters
    
    it "should produce a correct link" do
      stylesheet('styles.css').should == "<link href=\"/theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end
    
    it "should append .css if not given" do
      stylesheet('styles').should == "<link href=\"/theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end

    it "should add the media resource" do
      stylesheet('styles', 'all').should == "<link href=\"/theme/stylesheets/styles.css\" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />"
    end
    
    it "should render correctly through liquid" do
      render_liquid("{{ 'styles' | stylesheet }}").should == "<link href=\"/theme/stylesheets/styles.css\" rel=\"stylesheet\" type=\"text/css\" />"
    end
  end

  describe "javascript method" do
    define_models :url_filters
    
    it "should produce a correct link" do
      javascript('scripts.js').should == "<script src=\"/theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end
    
    it "should append .js if not given" do
      javascript('scripts').should == "<script src=\"/theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end

    it "should render correctly through liquid" do
      render_liquid("{{ 'scripts' | javascript }}").should == "<script src=\"/theme/javascripts/scripts.js\" type=\"text/javascript\"></script>"
    end
  end
  
  describe "link_to_news method" do
    it "should produce a link to the news page with the given text" do
      link_to_news('Check it out').should == '<a href="/news_items">Check it out</a>'
    end
    
    it "should default to News if no text is given" do
      link_to_news().should == '<a href="/news_items">News</a>'
    end
  end
end
