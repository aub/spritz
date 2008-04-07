require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  define_models :users
  
  describe 'being created' do
    define_models :users
    
    before do
      @user = nil
      @creating_user = lambda do
        @user = create_user
        violated "#{@user.errors.full_messages.to_sentence}" if @user.new_record?
      end
    end
    
    it 'increments User#count' do
      @creating_user.should change(User, :count).by(1)
    end

    it 'initializes #activation_code' do
      @creating_user.call
      @user.reload.activation_code.should_not be_nil
    end

    it 'starts in pending state' do
      @creating_user.call
      @user.should be_pending
    end
  end

  it 'requires login' do
    lambda do
      u = create_user(:login => nil)
      u.errors.on(:login).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires password' do
    lambda do
      u = create_user(:password => nil)
      u.errors.on(:password).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = create_user(:password_confirmation => nil)
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires email' do
    lambda do
      u = create_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'resets password' do
    users(:admin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    User.authenticate('admin', 'new password').should == users(:admin)
  end

  it 'does not rehash password' do
    users(:admin).update_attributes(:login => 'admin2')
    User.authenticate('admin2', 'test').should == users(:admin)
  end

  it 'authenticates user' do
    User.authenticate('admin', 'test').should == users(:admin)
  end

  it 'sets remember token' do
    users(:admin).remember_me
    users(:admin).remember_token.should_not be_nil
    users(:admin).remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    users(:admin).remember_me
    users(:admin).remember_token.should_not be_nil
    users(:admin).forget_me
    users(:admin).remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    users(:admin).remember_me_for 1.week
    after = 1.week.from_now.utc
    users(:admin).remember_token.should_not be_nil
    users(:admin).remember_token_expires_at.should_not be_nil
    users(:admin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    users(:admin).remember_me_until time
    users(:admin).remember_token.should_not be_nil
    users(:admin).remember_token_expires_at.should_not be_nil
    users(:admin).remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    users(:admin).remember_me
    after = 2.weeks.from_now.utc
    users(:admin).remember_token.should_not be_nil
    users(:admin).remember_token_expires_at.should_not be_nil
    users(:admin).remember_token_expires_at.between?(before, after).should be_true
  end

  it 'registers passive user' do
    user = create_user(:password => nil, :password_confirmation => nil)
    user.should be_passive
    user.update_attributes(:password => 'new password', :password_confirmation => 'new password')
    user.register!
    user.should be_pending
  end

  it 'suspends user' do
    users(:admin).suspend!
    users(:admin).should be_suspended
  end

  it 'does not authenticate suspended user' do
    users(:admin).suspend!
    User.authenticate('admin', 'test').should_not == users(:admin)
  end

  it 'deletes user' do
    users(:admin).deleted_at.should be_nil
    users(:admin).delete!
    users(:admin).deleted_at.should_not be_nil
    users(:admin).should be_deleted
  end

  describe "being unsuspended" do
    define_models :users

    before do
      @user = users(:admin)
      @user.suspend!
    end
    
    it 'reverts to active state' do
      @user.unsuspend!
      @user.should be_active
    end
    
    it 'reverts to passive state if activation_code and activated_at are nil' do
      User.update_all :activation_code => nil, :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_passive
    end
    
    it 'reverts to pending state if activation_code is set and activated_at is nil' do
      User.update_all :activation_code => 'foo-bar', :activated_at => nil
      @user.reload.unsuspend!
      @user.should be_pending
    end
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.register! if record.valid?
    record
  end
end
