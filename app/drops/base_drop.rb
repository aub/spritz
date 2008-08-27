class BaseDrop < Liquid::Drop
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]

  class_inheritable_reader :liquid_associations
  write_inheritable_attribute :liquid_associations, []
  
  attr_reader :source

  # There are two helpers being defined here. The first is liquid attributes.
  # A drop can have a declaration like:
  #
  # liquid_attributes << :title << :name << :text
  #
  # and this will create methods that cache and return the attribute with the
  # specified name from the source. The second helper is for associations.
  # The controller can have a declaration like:
  #
  # liquid_associations << :links << :news_items << { :portfolios => :root_portfolios }
  #
  # This will create helper methods for the associations so that the drop will return
  # a list of links, news items with methods of the same name. It can also take a hash.
  # In the example here, it will create a method called 'portfolios' that returns the
  # value of the association :root_portfolios in the source object. These methods also
  # play a role in the caching system, so it should be used whenever possible.
  def initialize(source)
    @source = source
    @cached = liquid_attributes.inject({}) { |hash, att| hash.update att.to_s => nil }
    liquid_associations.each { |a| add_association_helper(a) }
  end
    
  def context=(ctxt)
    @controller = ctxt.registers[:controller]
    @controller.send(:cached_references) << @source if @source && @controller
  end
  
  def before_method(method)
    @cached[method] ||= liquidate(source.send(method)) if @cached.has_key?(method)
  end
  
  # Drops should be equal to another drop if the sources are the same or if the object is
  # the source.
  def ==(comparison_object)
    self.source == (comparison_object.is_a?(self.class) ? comparison_object.source : comparison_object)
  end
  
  def liquidate(s)
    s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;")
  end
  
  protected
  
  # This is a helper method for adding methods to return the paths of each of the
  # versions of an image. The attachment_name parameter should be the name of the
  # attachment as created in the model. The param_name is the name by which it is
  # referred to in the drop. So, if you have an attachment called 'hack' in the model
  # and want to have methods like 'foo_tiny_path', you should pass (:hack, :foo). If
  # the param_name is empty, methods with no prefix will be created, like tiny_path.
  def has_attached_image(attachment_name, param_name=nil)
    Spritz::ASSET_STYLES.keys.each do |image_name|
      method_name = (param_name.blank? ? '' : "#{param_name}_") + "#{image_name}_path"
      eval <<-END
        def #{method_name}
          @#{attachment_name}_#{image_name}_path ||= source.#{attachment_name}.file? ? source.#{attachment_name}.url(:#{image_name}) : ''
        end
      END
    end
  end
  
  def add_association_helper(a)
    if a.is_a?(Hash)
      association_name, association_value = a.keys[0].to_s, a.values[0].to_s
    elsif a.is_a?(Symbol)
      association_name = association_value = a.to_s
    end
    return if association_name.nil? || association_value.nil?
    
    eval <<-END
      def #{association_name}
        @#{association_name} = source.#{association_value}
        @controller.send(:cached_references) << @#{association_name} unless @controller.nil?
        @#{association_name}
      end
    END
  end
  
end