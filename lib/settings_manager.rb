module SettingsManager
  
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    
    def fields
      @fields ||= {}
    end
    
    def setting(name, type, default)
      fields[name] = Field.new(name, type, default)
      add_setting_accessor(fields[name])
    end
    
    private
    
    def add_setting_accessor(field)
      add_setting_reader(field)
      add_setting_writer(field)
    end
    
    def add_setting_reader(field)
      self.send(:define_method, "#{field.name}") do
        raw_value = settings[field.name]
        raw_value.nil? ? field.default : raw_value
      end
      if field.ruby_type == :boolean
        self.send(:define_method, "#{field.name}?") do
          raw_value = settings[field.name]
          raw_value.nil? ? field.default : raw_value
        end
      end
    end
    
    def add_setting_writer(field)
      self.send(:define_method, "#{field.name}=") do |newvalue|
        retval = settings[field.name] = canonicalize(field.name, newvalue)
        self.save! unless new_record?
        retval
      end
    end
  end
  
  def canonicalize(key, value)
    self.class.fields[key].canonicalize(value)
  end
  
  class Field
    attr_accessor :name, :ruby_type, :default
    
    def initialize(name_arg, type_arg, default_arg)
      self.name = name_arg
      self.ruby_type = type_arg
      self.default = default_arg
    end
    
    def canonicalize(value)
      case ruby_type
      when :boolean
        case value
        when "0", 0, '', false, "false", "f", nil
          false
        else
          true
        end
      when :integer
        value.to_i
      when :string
        value.to_s
      when :yaml
        value.to_yaml
      else
        value
      end
    end
  end
end