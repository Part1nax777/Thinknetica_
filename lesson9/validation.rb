module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(name, type, *arg)
      @validations ||= []
      @validations << { type: type, name: name, arg: arg }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    protected

    def validate!
      self.class.validations.each do |rule|
        rule.each do |type, params|
          value = get_instance_var_by_name(params[:name])
          send("validate_#{type}", value, *params[:arg])
        end
      end
    end

    def validate_presence(value)
      raise 'Value is not be empty' if value.nil? || value.empty?
    end

    def validate_format(value, format)
      raise 'Value have incorrect format' if value !~ format
    end

    def validate_type(value, attribute_class)
      raise 'Object another class' unless value.is_a?(attribute_class)
    end

    def get_instance_var_by_name(name)
      var_name = "@#{name}".to_s
      instance_variable_get(var_name)
    end
  end
end
