class PortfolioSectionDrop < SectionDrop

  def portfolio_pages
    @pages ||= @source.portfolio_pages.collect(&:to_liquid)
  end
end