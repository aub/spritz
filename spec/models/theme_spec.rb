require File.dirname(__FILE__) + '/../spec_helper'

describe Theme do

  it "should have a theme root" do
    Theme.theme_root.should == File.join(RAILS_ROOT, 'tmp', 'themes')
  end
  
  it "should find the path for a given theme name" do
    Theme.theme_path('ack').should == File.join(RAILS_ROOT, 'tmp', 'themes', 'ack')
  end
  
  it "should have a find method for creating a theme with a given name" do
    Theme.find('booya').should eql(Theme.new('booya', File.join(RAILS_ROOT, 'tmp', 'themes', 'booya')))
  end
  
  it "should provide a useful equality operator" do
    Theme.new('a', File.join(RAILS_ROOT, 'a')).should eql(Theme.new('a', File.join(RAILS_ROOT, 'a')))
  end
  
  it "should provide the location of the theme" do
    Theme.find('testy').layout.should == File.join(%w(.. layouts default))
  end
end
