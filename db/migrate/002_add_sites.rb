class AddSites < ActiveRecord::Migration
  def self.up
    create_table :sites, :force => true do |t|
      t.string :subdomain, :domain
      t.timestamps
    end
    
    add_index :sites, [:domain, :subdomain], :name => "index_sites_on_domain_and_subdomain"
  end

  def self.down
    drop_table :sites
  end
end
