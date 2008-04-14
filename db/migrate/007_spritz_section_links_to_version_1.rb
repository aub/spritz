class SpritzSectionLinksToVersion1 < ActiveRecord::Migration
  def self.up
    Engines.plugins["spritz_section_links"].migrate(1)
  end

  def self.down
    Engines.plugins["spritz_section_links"].migrate(0)
  end
end
