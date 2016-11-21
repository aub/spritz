module Spritz
  @@multi_sites_enabled = false
  mattr_accessor :multi_sites_enabled
  
  ASSET_STYLES = { :display => '600x400>', :medium => '400x300>', :thumbnail => '70x70#', :tiny => '35x35#' }
end