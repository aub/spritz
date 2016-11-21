class UsePaperclipForHomeImage < ActiveRecord::Migration
  def self.up
    change_table :sites do |t|
      t.string :home_image_file_name
      t.string :home_image_content_type
      t.integer :home_image_file_size
      t.datetime :home_image_updated_at
    end
  end

  def self.down
    change_table :sites do |t|
      t.remove :home_image_file_name
      t.remove :home_image_content_type
      t.remove :home_image_file_size
      t.remove :home_image_updated_at
    end
  end
end
