class AddSections < ActiveRecord::Migration
  def self.up
    create_table :sections, :force => true do |t|
      t.references :site
      t.boolean :active, :default => true
      t.integer :position, :default => 1
      t.text :options
      t.string :type, :name
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
