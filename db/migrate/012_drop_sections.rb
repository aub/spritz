class DropSections < ActiveRecord::Migration
  def self.up
    drop_table :sections
  end

  def self.down
    create_table :sections, :force => true do |t|
      t.references :site
      t.boolean :active, :default => true
      t.integer :position, :default => 1
      t.text :options
      t.string :type
      t.string :title
      t.timestamps
    end
  end
end
