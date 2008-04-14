class Section < ActiveRecord::Base
  
  belongs_to :site

  def to_liquid
    SectionDrop.new self
  end
end