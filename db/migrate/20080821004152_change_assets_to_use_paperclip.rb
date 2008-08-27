class ChangeAssetsToUsePaperclip < ActiveRecord::Migration
  def self.up
    change_table :assets do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      
      t.remove :content_type
      t.remove :filename
      t.remove :size
      t.remove :parent_id
      t.remove :thumbnail
      t.remove :width
      t.remove :height
      t.remove :thumbnails_count
    end
  end

  def self.down
    change_table :assets do |t|
      t.remove :attachment_file_name
      t.remove :attachment_content_type
      t.remove :attachment_file_size
      t.remove :attachment_updated_at
      
      t.string :content_type, :filename, :thumbnail
      t.integer :size, :parent_id, :width, :height, :thumbnails_count
    end
  end
end
