class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships, :force => true do |t|
      t.references :user, :site
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
  end
end
