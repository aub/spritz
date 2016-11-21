require File.dirname(__FILE__) + '/../../spec_helper'

describe TextFilters do
  include TextFilters
  
  define_models :text_filters
  
  describe "limit_length method" do
    it "should trim a given string" do
      limit_length('1234567890', 5).should == '12345...'
    end
    
    it "should strip spaces when trimming" do
      limit_length('123       ', 5).should == '123...'
    end
  end
end
