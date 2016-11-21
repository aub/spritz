class CreatePortfolios < ActiveRecord::Migration
  def self.up
    create_table :portfolios, :force => true do |t|
      t.references :site
      t.integer :parent_id, :lft, :rgt
      t.string :title
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :portfolios
  end
end
