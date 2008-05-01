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
      class_eval <<-END, __FILE__, __LINE__
        def #{field.name}
          write_attribute(:settings, {}) if read_attribute(:settings).nil?
          settings[#{field.name.inspect}].blank? ? #{field.default.inspect} : settings[#{field.name.inspect}]
        end
        
        def #{field.name}=(value)
          write_attribute(:settings, {}) if read_attribute(:settings).nil?
          settings[#{field.name.inspect}] = canonicalize(#{field.name.inspect}, value)
        end
      END
      if field.ruby_type == :boolean
        class_eval <<-END, __FILE__, __LINE__
            def #{field.name}?
              write_attribute(:settings, {}) if read_attribute(:settings).nil?
              settings[#{field.name.inspect}].blank? ? #{field.default.inspect} : settings[#{field.name.inspect}]
            end
          END
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