require File.dirname(__FILE__) + '/../../spec_helper'

describe SectionList do
  define_models :section_list do
    model Portfolio do
      stub :one, :site => all_stubs(:site), :title => 'One'
      stub :two, :site => all_stubs(:site), :title => 'Two'
    end
    model Link do
      stub :one, :site => all_stubs(:site)
    end
    model NewsItem do
      stub :one, :site => all_stubs(:site)
    end
  end
  
  it "should register itself as a liquid tag" do
    Liquid::Template.tags['sectionlist'].should == SectionList
  end
  
  it "should require the tag to be closed" do
    lambda { render_liquid('{% sectionlist %}') }.should raise_error(SyntaxError)
  end
  
  it "should require the correct format for the tag" do
    lambda { render_liquid('{% sectionlist %} {% endsectionlist %}') }.should raise_error(SyntaxError)
  end
  
  it "should not raise an error with correct syntax in the tag" do
    lambda { render_liquid('{% sectionlist as section %} {% endsectionlist %}') }.should_not raise_error
  end
  
  it "should render an empty string with an empty tag" do
    render_liquid('{% sectionlist as section %} {% endsectionlist %}').strip.should == ''
  end
  
  it "should render the sections urls as requested" do
    content = '{% sectionlist as section %} {{ section.url }} {% endsectionlist %}'
    render_liquid(content).split(' ').collect(&:strip).sort.should == [
      '/contact/new', '/links', '/news_items', "/portfolios/#{portfolios(:one).to_param}", "/portfolios/#{portfolios(:two).to_param }" ].sort
  end
  
  it "should render the sections titles as requested" do
    content = '{% sectionlist as section %} {{ section.title }} {% endsectionlist %}'
    render_liquid(content).split(' ').collect(&:strip).sort.should == [
      'Contact', 'Links', 'News', "#{portfolios(:one).title}", "#{portfolios(:two).title}" ].sort
  end
  
  it "should not render the Links section if there are no links" do
    Link.find(:all).each(&:destroy)
    content = '{% sectionlist as section %} {{ section.title }} {% endsectionlist %}'
    render_liquid(content).split(' ').collect(&:strip).include?('Links').should be_false
  end
  
  it "should not render the News section if there is no news" do
    NewsItem.find(:all).each(&:destroy)
    content = '{% sectionlist as section %} {{ section.title }} {% endsectionlist %}'
    render_liquid(content).split(' ').collect(&:strip).include?('News').should be_false
  end
end
