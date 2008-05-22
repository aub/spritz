class ResumeSection < ActiveRecord::Base
  
  belongs_to :site
  
  has_many :resume_items, :order => :position, :dependent => :destroy do
    # change the order of the assigned_assets in the portfolio by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_resume_items, sorted_ids)
    end
  end
  
  validates_presence_of :title

  def to_liquid
    ResumeSectionDrop.new self
  end

  protected
  
  # A helper method for reordering the assigned assets.
  def reorder_resume_items(*sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |thing_id, pos|
        ResumeItem.update_all ['position = ?', pos], ['id = ? and resume_section_id = ?', thing_id, self.id]
      end
    end
  end
  
end
