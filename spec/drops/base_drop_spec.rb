require File.dirname(__FILE__) + '/../spec_helper'

describe BaseDrop do
  
  BaseDrop.liquid_attributes.push(*[:test1, :test2])
  
  before(:each) do
    @site = mock_model(Site, :id => '13', :test1 => 't1', :test2 => 't2', :test3 => 't3')
    @drop = BaseDrop.new(@site)
  end
  
  it "should allow reading of the source object" do
    @drop.source.should == @site
  end
  
  it "should perform == comparisons based on the source object" do
    BaseDrop.new(@site).should == BaseDrop.new(@site)
  end
  
  it "should perform == comparisons without a drop" do
    BaseDrop.new(@site).should == @site
  end

  describe "url method" do
    it "should create a url for sources that support it" do
      @site.stub!(:to_url).and_return(%w(a b))
      @drop.url.should == '/a/b'
    end
    
    it "should return nil for the url when the source doesn't support it" do
      BaseDrop.new(mock_model(Site)).url.should  be_nil
    end
  end

  describe "attributes" do    
    before(:each) do
      @drop = BaseDrop.new(@site)
    end
    
    it "should provide a list of default attributes" do
      @drop.liquid_attributes.should == [:id, :test1, :test2]
    end
  
    it "should provide access to the attributes through the before_method" do
      %w(test1 test2).each { |method| @drop.before_method(method).should == @site.send(method) }
    end
    
    it "should not provide access to methods that are not in the attributes" do
      @drop.before_method('test3').should == nil
    end
    
    it "should cache attribute values" do
      @drop.before_method('test1')
      @site.should_not_receive(:test1)
      @drop.before_method('test1')
    end
  end
  
  describe "cache support" do
    before(:each) do
      @a = []
      @controller = mock_model(HomeController)
      @controller.stub!(:cached_references).and_return(@a)
      @context = mock_context({}, { :controller => @controller })
    end
    
    it "should call cached_references in the controller from the context" do
      @controller.should_receive(:cached_references).and_return([])
      @drop.context = @context
    end
    
    it "should add the current source to the cached references" do
      @drop.context = @context
      @a.should == [@site]
    end
  end
end
