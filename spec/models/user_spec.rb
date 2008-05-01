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
    User.authenticate_for(sites(:default), 'admin', 'new password').should == users(:admin)
  end
  
  it 'does not rehash password' do
    users(:admin).update_attributes(:login => 'admin2')
    User.authenticate_for(sites(:default), 'admin2', 'test').should == users(:admin)
  end
  
  describe "authentication" do
    define_models :users
    
    it "should authenticates users by site" do
      User.authenticate_for(sites(:default), 'admin', 'test').should == users(:admin)
    end
    
    it "should not authenticate for a non-member site" do
      User.authenticate_for(sites(:other), 'nonadmin', 'test').should be_nil
    end
    
    it "should authenticate admin for all sites" do
      User.authenticate_for(sites(:other), 'admin', 'test').should == users(:admin)
    end
    
    it "should fail authentication with the wrong login/password" do
      User.authenticate_for(sites(:other), 'admin', 'oops').should be_nil
    end
    
    it "should not authenticate suspended users" do
      users(:admin).suspend!
      User.authenticate_for(sites(:default), 'admin', 'test').should be_nil
    end
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

  describe "relationship to memberships" do
    define_models :users
    
    it "should have many memberships" do
      users(:admin).memberships.sort_by(&:site_id).should == [memberships(:admin_on_default), memberships(:admin_on_other)].sort_by(&:site_id)
    end
    
    it "should have sites through memberships" do
      users(:admin).sites.sort_by(&:id).should == [sites(:default), sites(:other)].sort_by(&:id)
    end
    
    it "should destroy memberships when being destroyed" do
      lambda { users(:admin).destroy }.should change(Membership, :count).by(-2)
    end
  end

  describe "overriden find methods" do
    define_models :users
    
    it "should find a user by site" do
      User.find_by_site(sites(:default), users(:nonadmin).id).should == users(:nonadmin)
    end
    
    it "should fail to find by site for a mismatch" do
      User.find_by_site(sites(:other), users(:nonadmin).id).should be_nil
    end
    
    it "should find the admin user for all sites" do
      User.find_by_site(sites(:other), users(:admin).id).should == users(:admin)
    end
  
    it "should find all users by site" do
      User.find_all_by_site(sites(:default)).sort_by(&:id).should == User.find(:all).sort_by(&:id)
    end
    
    it "should fail to find all by site for a mismatch" do
      User.find_all_by_site(sites(:other)).should == [users(:admin)]
    end
    
    it "should find a user by remember token" do
      User.find_by_remember_token(sites(:default), users(:nonadmin).remember_token).should == users(:nonadmin)
    end
    
    it "should fail to find by remember_token for a mismatch" do
      User.find_by_remember_token(sites(:other), users(:nonadmin).remember_token).should be_nil
    end
    
    it "should find the admin user for all sites by remember token" do
      User.find_by_remember_token(sites(:other), users(:admin).remember_token).should == users(:admin)
    end
  end

protected
  def create_user(options = {})
    record = User.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    record.register! if record.valid?
    record
  end
end
