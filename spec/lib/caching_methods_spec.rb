require File.dirname(__FILE__) + '/../spec_helper'

class HackController < ApplicationController
end

describe "CachingMethods" do
  
  describe "with multi-site enabled" do
    before(:each) do
      @hack = HackController.new
      Site.multi_sites_enabled = true
    end
    
    it "should call caches_action for the with_references call" do
      @hack.class.should_receive(:caches_action)
      @hack.class.send(:caches_with_references)
    end
  end
  
  describe "with multi-site disabled" do
    before(:each) do
      @hack = HackController.new
      Site.multi_sites_enabled = false
    end
    
    it "should call caches_page for the with_references call" do
      @hack.class.should_receive(:caches_action)
      @hack.class.send(:caches_with_references)
    end
  end
end
