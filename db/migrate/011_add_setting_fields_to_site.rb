class AddSettingFieldsToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :theme, :string
    add_column :sites, :title, :string
    remove_column :sites, :settings
  end

  def self.down
    remove_column :sites, :theme
    remove_column :sites, :title
    add_column :sites, :settings, :text
  end
end
