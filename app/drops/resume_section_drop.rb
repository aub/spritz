class ResumeSectionDrop < BaseDrop
  liquid_attributes << :title
  liquid_associations << { :items => :resume_items }
end