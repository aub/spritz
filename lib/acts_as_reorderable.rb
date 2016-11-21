module ActsAsReorderable
  def acts_as_reorderable(options={})
    # only need to define these once on a class
    unless included_modules.include?(InstanceMethods)
      extend  ClassMethods
      include InstanceMethods      
    end
  end
  
  module ClassMethods
    def reorder!(*sorted_ids)
      transaction do
        sorted_ids.flatten.each_with_index do |thing_id, pos|
          self.find(thing_id).update_attribute(:position, pos)
        end
      end
    end
  end
  
  module InstanceMethods
  end
end