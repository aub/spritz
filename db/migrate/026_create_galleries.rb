class CreateGalleries < ActiveRecord::Migration
  def self.up
    create_table :galleries do |t|
      t.references :site
      t.string :name, :address, :city, :state, :zip, :country, :phone, :email, :url
      t.text :description, :description_html
      t.integer :position, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :galleries
  end
end
