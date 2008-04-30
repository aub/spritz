class PortfolioDrop < BaseDrop
  liquid_attributes << :title << :body
  
  def assets
    @assets ||= source.assigned_assets.collect(&:to_liquid)
  end
end