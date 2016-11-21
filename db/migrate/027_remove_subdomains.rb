class RemoveSubdomains < ActiveRecord::Migration
  def self.up
    remove_index :sites, :name => "index_sites_on_domain_and_subdomain"
    remove_column :sites, :subdomain
    add_index :sites, :domain, :name => "index_sites_on_domain"
  end

  def self.down
    add_column :sites, :subdomain, :string
    add_index :sites, [:domain, :subdomain], :name => "index_sites_on_domain_and_subdomain"
    remove_index :sites, :name => 'index_sites_on_domain'
  end
end
