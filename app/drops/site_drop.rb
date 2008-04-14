class SiteDrop < BaseDrop
  liquid_attributes << :title
  
  def sections
    @sections ||= @source.sections.active.collect(&:to_liquid)
  end
end