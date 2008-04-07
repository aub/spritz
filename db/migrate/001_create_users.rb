class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
      t.column :state, :string, :null => :no, :default => 'passive'
      t.column :deleted_at, :datetime
      t.column :admin, :boolean, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
