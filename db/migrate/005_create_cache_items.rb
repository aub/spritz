class CreateCacheItems < ActiveRecord::Migration
  def self.up
    create_table :cache_items, :force => true do |t|
      t.references :site
      t.text :references
      t.string :type, :path
      t.timestamps
    end
  end

  def self.down
    drop_table :cache_items
  end
end
