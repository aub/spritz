class Portfolio < ActiveRecord::Base
  
  belongs_to :site

  acts_as_reorderable
  acts_as_nested_set :scope => :site_id

  column_to_html :body

  validates_presence_of :title
  validates_length_of :title, :maximum => 100
  
  has_many :assigned_assets, :as => :asset_holder, :dependent => :destroy, :order => 'position'
  has_many :assets, :through => :assigned_assets, :order => 'assigned_assets.position'

  has_attached_file :cover_image, :styles => Spritz::ASSET_STYLES
  
  attr_accessible :title, :body, :position, :cover_image

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
      child.save # Needed in order for the sweeper to work properly
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
end
