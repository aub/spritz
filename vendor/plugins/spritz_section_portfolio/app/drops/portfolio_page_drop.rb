class PortfolioPageDrop < BaseDrop
  liquid_attributes << :name
  
  def children
    @children ||= source.children.collect(&:to_liquid)
  end
end