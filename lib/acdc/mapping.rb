module AcDc
  module Mapping
    
    def self.included(base)
      base.instance_variable_set("@attributes",{})
      base.instance_variable_set("@elements",{})
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attributes
        @attributes[to_s] || []
      end

      def elements
        @elements[to_s] || []
      end  

      def attribute(name, type, options={})
        attribute = Attribute.new(name,type,options)
        @attributes[to_s] ||= []
        @attributes[to_s] << attribute
        unless @inheritance_chain.nil? 
          @inheritance_chain.each { |child| child.attribute(name,type,options) }
        end
        make_accessor(attribute)
      end

      def element(name, type, options={})
        element = Element.new(name,type,options)
        @elements[to_s] ||= []
        @elements[to_s] << element
        unless @inheritance_chain.nil?
          @inheritance_chain.each { |child| child.element(name,type,options) }
        end
        make_accessor(element)
      end

      def tag_name(name = nil)
        @tag_name = name.to_s if name
        @tag_name ||= to_s.split('::')[-1].downcase
      end

      def namespace(namespace = nil)
        @namespace = namespace if namespace
        @namespace
      end
      
      private
        def make_accessor(item)
          safe_name = item.name.tr('-','_')
          if instance_methods.include?(safe_name)
            name = "#{item.element? ? "element_" : "attribute_"}#{safe_name}"
            item.name = name
          end
          attr_accessor item.method_name.intern
        end

    end
    
  end
end