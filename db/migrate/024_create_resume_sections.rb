class CreateResumeSections < ActiveRecord::Migration
  def self.up
    create_table :resume_sections do |t|
      t.references :site
      t.string :title
      t.integer :position, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :resume_sections
  end
end
