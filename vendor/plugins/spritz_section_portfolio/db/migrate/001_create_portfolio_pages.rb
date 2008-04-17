class CreatePortfolioPages < ActiveRecord::Migration
  def self.up
    create_table :portfolio_pages, :force => true do |t|
      t.references :section
      t.string :name
      t.string :junk
      t.timestamps
    end
  end

  def self.down
    drop_table :portfolio_pages
  end
end
