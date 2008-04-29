class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :content_type
      t.string :filename
      t.integer :size
      t.integer :parent_id
      t.string :thumbnail
      t.integer :width
      t.integer :height
      t.integer :site_id
      t.integer :thumbnails_count
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
