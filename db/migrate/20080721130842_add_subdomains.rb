class AddSubdomains < ActiveRecord::Migration
  def self.up
    remove_index :sites, :name => "index_sites_on_domain"
    
    change_table :sites do |t|
      t.string :subdomain
    end

    add_index :sites, [:domain, :subdomain], :name => "index_sites_on_domain_and_subdomain"
  end

  def self.down
    remove_index :sites, :name => "index_sites_on_domain_and_subdomain"
    
    change_table :sites do |t|
      t.remove :subdomain
    end
    
    add_index :sites, :domain, :name => "index_sites_on_domain"
  end
end
