class SiteThemeToThemePath < ActiveRecord::Migration
  def self.up
    rename_column :sites, :theme, :theme_path
  end

  def self.down
    rename_column :sites, :theme_path, :theme
  end
end
