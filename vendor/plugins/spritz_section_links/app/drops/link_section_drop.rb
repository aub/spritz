class LinkSectionDrop < SectionDrop

  def links
    @links ||= @source.links.collect(&:to_liquid)
  end
end