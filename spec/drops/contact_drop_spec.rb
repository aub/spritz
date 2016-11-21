require File.dirname(__FILE__) + '/../spec_helper'

describe ContactDrop do
  define_models :contact_drop do
    model Contact do
      stub :one, :site => all_stubs(:site), :name => 'Bob', :email => 'bob@bob.com', :phone => '123-456-7890', :message => 'booya!'
    end
  end
  
  before(:each) do
    @drop = ContactDrop.new(contacts(:one))
  end

  it "should provide access to the name" do
    @drop.before_method('name').should == contacts(:one).name
  end
  
  it "should provide access to the email" do
    @drop.before_method('email').should == contacts(:one).email
  end
  
  it "should provide access to the phone" do
    @drop.before_method('phone').should == contacts(:one).phone
  end
  
  it "should provide access to the email" do
    @drop.before_method('message').should == contacts(:one).message
  end
  
  describe "getting errors from the contact" do
    define_models :contact_drop
    
    it "should produce an error when no name is given" do
      @drop = ContactDrop.new(Contact.new(:email => 'a@b.com')).errors.should == ["Please provide your name"]
    end
    
    it "should produce an error when no email is given" do
      @drop = ContactDrop.new(Contact.new(:name => 'hacky')).errors.should == ["Please provide your email address"]
    end
    
    it "should produce an error when an invalid email is given" do
      @drop = ContactDrop.new(Contact.new(:name => 'hacky', :email => 'yuck')).errors.should == ["Please provide a valid email address"]
    end
  end
end
