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