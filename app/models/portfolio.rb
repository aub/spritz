class Portfolio < ActiveRecord::Base
  
  belongs_to :site
  
  acts_as_nested_set :scope => :site_id

  # column_to_html :body
  before_save :convert_column_to_html

  validates_presence_of :title
  validates_length_of :title, :maximum => 100
  
  has_many :assigned_assets, :as => :asset_holder, :dependent => :destroy, :order => :position do
    # change the order of the assigned_assets in the portfolio by passing an ordered list of their ids
    def reorder!(*sorted_ids)
      proxy_owner.send(:reorder_assigned_assets, sorted_ids)
    end    
  end
  has_many :assets, :through => :assigned_assets, :order => 'assigned_assets.position'
  
  attr_accessible :title, :body, :position

  # Reorder the children according to the list of ids given.
  def reorder_children!(*sorted_ids)
    return if children.empty?
    last_moved = nil
    sorted_ids.flatten.each do |child_id|
      child = children.find { |item| item.id.to_s == child_id.to_s }
      next if child.nil?
      if last_moved.nil?
        child.move_to_left_of(children[0]) unless child == children[0]
      else
        child.move_to_right_of(last_moved)
      end
      last_moved = child
    end
  end
  
  # Helper for getting the position of the last asset so we can add new ones after it.
  def last_asset_position
    (assigned_assets.size > 0) ? assigned_assets.last.position : 0
  end
  
  def to_liquid
    PortfolioDrop.new self
  end
  
  protected
  
  def convert_column_to_html
    self.body_html = RedCloth.new(self.body || '').to_html
  end

  # A helper method for reordering the assigned assets.
  def reorder_assigned_assets(*sorted_ids)
    transaction do
      sorted_ids.flatten.each_with_index do |thing_id, pos|
        assigned_assets.find(thing_id).update_attribute(:position, pos)
      end
    end
  end
end
