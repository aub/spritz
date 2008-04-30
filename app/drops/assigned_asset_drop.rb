class AssignedAssetDrop < BaseDrop
  
  def display_path
    @display_path ||= source.asset.public_filename(:display)
  end
  
  def thumbnail_path
    @thumbnail_path ||= source.asset.public_filename(:thumb)
  end
end