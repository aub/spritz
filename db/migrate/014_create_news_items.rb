class CreateNewsItems < ActiveRecord::Migration
  def self.up
    create_table :news_items do |t|
      t.references :site
      t.string :title
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :news_items
  end
end
