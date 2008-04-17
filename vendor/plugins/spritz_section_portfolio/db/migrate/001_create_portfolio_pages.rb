class CreatePortfolioPages < ActiveRecord::Migration
  def self.up
    create_table :portfolio_pages, :force => true do |t|
      t.integer  :parent_id
      t.integer  :section_id
      t.integer  :lft
      t.integer  :rgt
      t.string   :name
      t.string   :path
      t.text     :body
      t.timestamps
    end
  end

  def self.down
    drop_table :portfolio_pages
  end
end
