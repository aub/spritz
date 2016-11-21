class CreateResumeItems < ActiveRecord::Migration
  def self.up
    create_table :resume_items do |t|
      t.references :resume_section
      t.text :text
      t.text :text_html
      t.integer :position, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :resume_items
  end
end
