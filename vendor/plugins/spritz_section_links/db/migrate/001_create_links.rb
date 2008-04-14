class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links, :force => true do |t|
      t.references :section
      t.string :url
      t.string :title
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
