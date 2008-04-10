class BaseDrop < Liquid::Drop
  class_inheritable_reader :liquid_attributes
  write_inheritable_attribute :liquid_attributes, [:id]
  
  attr_reader :source
  
  def initialize(source)
    @source = source
    @cached = liquid_attributes.inject({}) { |hash, att| hash.update att.to_s => nil }
  end
  
  def context=(ctxt)
    ctxt.registers[:controller].send(:cached_references) << @source if @source && ctxt.registers[:controller]
  end
  
  def before_method(method)
    @cached[method] ||= source.send(method) if @cached.has_key?(method)
  end
end