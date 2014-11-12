require 'active_support/concern'
require 'active_model/dirty'

module BaseModelHelper

  extend ActiveSupport::Concern

  include ActiveModel::Dirty

  def save

    if self.respond_to?(:before_save)
      self.before_save
    end

    unless self.class.json_attributes.blank?
      self.class.json_attributes.each do |attr|
        self.instance_variable_set("@__#{attr}_original", self.send(attr).blank? ?  nil : self.send(attr).dup )
      end
    end

    @previously_changed = changes
    @changed_attributes.clear
  end

  module ClassMethods

    def json_attributes
      self.class_variable_get(:@@json_attributes)
    end

    def define_dirty_attributes(*attr_names)
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        define_attribute_methods #{attr_names.to_s}
      RUBY_EVAL

      attr_names.each do |attr_name|
        class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
          def #{attr_name}
            @#{attr_name}
          end

          def #{attr_name}=(val)
            #{attr_name}_will_change! unless val == @#{attr_name}
            @#{attr_name} = val
          end
        RUBY_EVAL
      end
    end

    def define_json_attributes(*attr_names)
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        @@json_attributes = #{attr_names.collect{|a| a.to_s}.to_s}
      RUBY_EVAL
    end

  end

end