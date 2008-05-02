require 'digest/sha1'
class User < ActiveRecord::Base
  @@membership_options = {:select => 'distinct users.*', :order => 'users.login',
    :joins => 'left outer join memberships on users.id = memberships.user_id'}

  attr_accessible :login, :email, :password, :password_confirmation
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  has_many :memberships, :dependent => :destroy
  has_many :sites, :through => :memberships
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  acts_as_state_machine :initial => :pending
  state :passive
  state :pending, :enter => :make_activation_code
  state :active,  :enter => :do_activate
  state :suspended
  state :deleted, :enter => :do_delete

  event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end
  
  event :activate do
    transitions :from => :pending, :to => :active 
  end
  
  event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end
  
  event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  # Authenticates a user by their site, login name and unencrypted password.  Returns the user or nil.
  def self.authenticate_for(site, login, password)
    user = find_in_state :first, :active, @@membership_options.merge(
      :conditions => ['users.login = ? and (memberships.site_id = ? or users.admin = ?)', login, site.id, true])
    user && user.authenticated?(password) ? user : nil
  end

  # Added as a helper to make sure we only find users who are members of the given site.
  def self.find_by_site(site, id)
    find(:first, @@membership_options.merge(
      :conditions => ['users.id = ? and (memberships.site_id = ? or users.admin = ?)', id, site.id, true]))
  end

  # And the pluralized version of above.
  def self.find_all_by_site(site, options = {})
    find(:all, @@membership_options.merge(options.reverse_merge(
      :conditions => ['memberships.site_id = ? or users.admin = ?', site.id, true]))).uniq
  end
  
  # Overriden to make sure the user is a member of the given site.
  def self.find_by_remember_token(site, token)
    find(:first, @@membership_options.merge(
      :conditions => ['remember_token = ? and remember_token_expires_at > ? and (memberships.site_id = ? or users.admin = ?)', token, Time.now.utc, site.id, true]))
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    def make_activation_code
      self.deleted_at = nil
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end
    
    def do_delete
      self.deleted_at = Time.now.utc
    end

    def do_activate
      self.activated_at = Time.now.utc
      self.deleted_at = self.activation_code = nil
    end
end
