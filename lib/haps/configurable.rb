module HAPS
  module Configurable
    extend self

    def option(name, default)
      attr_accessor name
      instance_variable_set "@#{name}", default

      define_method name do |*values|
        value = values.first
        value ? self.send("#{name}=", value) : instance_variable_get("@#{name}")
      end
    end

    def configure(&block)
      instance_eval &block
    end

  end
end
