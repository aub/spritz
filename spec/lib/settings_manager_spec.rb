require File.dirname(__FILE__) + '/../spec_helper'

class FakeClass < ActiveRecord::Base
  set_table_name 'sites'
  
  include SettingsManager
  def settings
    @settings ||= {}
  end
  def new_record? ; false ; end
  def save! ; true ; end
end

describe SettingsManager do
  
  describe "adding settings" do
    it "should provide access to the list of fields" do
      FakeClass.fields.should be_an_instance_of(Hash)
    end
    
    it "should add a Field to the fields when making a setting" do
      FakeClass.setting(:test, :boolean, true)
      FakeClass.fields[:test].should be_an_instance_of(SettingsManager::Field)
    end
    
    it "should set the appropriate values in the field when making a setting" do
      FakeClass.setting(:test, :boolean, true)
      field = FakeClass.fields[:test]
      field.name.should == :test
      field.ruby_type.should == :boolean
      field.default.should == true
    end
    
    it "should create an attribute writer for the setting" do
      FakeClass.setting(:test, :boolean, true)
      f = FakeClass.new
      f.test = false
      f.settings.should == { :test => false }
    end
    
    it "should canonicalize boolean values before saving" do
      FakeClass.setting(:test, :boolean, true)
      f = FakeClass.new
      f.test = 'f'
      f.settings.should == { :test => false }
    end
    
    it "should provide an attribute reader for the setting" do
      FakeClass.setting(:test, :integer, 2)
      f = FakeClass.new
      f.test = 12
      f.test.should == 12
    end
    
    it "should return the default value when none has been set" do
      FakeClass.setting(:test, :integer, 2)
      f = FakeClass.new
      f.test.should == 2
    end
    
    it "should provide a ? method for boolean settings" do
      FakeClass.setting(:test, :boolean, true)
      f = FakeClass.new
      f.should be_test
    end
  end
  
  describe "the internal Field class" do
    before(:each) do
      @field = SettingsManager::Field.new(:a, :b, :c)
    end
    
    it "should be buildable" do
      @field.should be_an_instance_of(SettingsManager::Field)
    end
    
    it "should give access to its data" do
      [:name, :ruby_type, :default].each do |item|
        @field.send("#{item.to_s}=", 'a_value')
        @field.send(item).should == 'a_value'
      end
    end
  end
end