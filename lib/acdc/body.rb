module AcDc
  class Body
    
    def self.inherited(child)
      attrs = @attributes.nil? ? [] : @attributes.dup
      child.instance_variable_set("@attributes", attrs)
      elems = @elements.nil? ? [] : @elements.dup
      child.instance_variable_set("@elements", elems)
      @inheritance_chain ||= []
      @inheritance_chain << child
    end    
    
    include(Build::ClassMethods)

    extend(Parsing)
    
    module BodyClassMethods
      
      def attributes
        @attributes || []
      end

      def elements
        @elements || []
      end  

      def attribute(name, type, options={})
        attribute = Attribute.new(name,type,options)
        @attributes ||= []
        @attributes << attribute
        unless @inheritance_chain.nil? 
          @inheritance_chain.each { |child| child.attributes << attribute }
        end
        attr_accessor attribute.method_name.intern
      end

      def element(name, type, options={})
        element = Element.new(name,type,options)
        @elements ||= []
        @elements << element
        unless @inheritance_chain.nil? 
          @inheritance_chain.each { |child| child.elements << element }
        end
        attr_accessor element.method_name.intern
      end

      def tag_name(name = nil)
        @tag_name = name.to_s if name
        @tag_name ||= to_s.split('::')[-1].downcase
      end

      def namespace(namespace = nil)
        @namespace = namespace if namespace
        @namespace
      end

    end
   
    extend(BodyClassMethods)
    
  end
end