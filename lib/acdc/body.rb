module AcDc
  class Body 
    
    attr_accessor :attributes, :elements
    
    # Populates the attributes and elements declared for this object.
    #@option values [Hash] :attributes Hash list of attributes to populate
    #@example Filling the values and attributes
    # class ThunderStruck < Body
    #   attribute :thunder
    #   element :lightning
    # end
    # kaboom = ThunderStruck.new({:attributes => {:thunder => "boom"}, :lightning => "crash"})
    def initialize(values = {})
      @attributes ||= {}
      @elements ||= {}
      # catch default values for attributes
      unless self.class.declared_attributes.values.all?{|val| val.nil?}
        self.class.declared_attributes.each do |key,val|
          attributes.update(key => Attribute(key,val)) unless val.nil?
        end
      end
      # now set initialized attribute values
      if values.has_key?(:attributes)
        values.delete(:attributes).each do |key,val|
          if self.class.declared_attributes.has_key?(key)
            attributes.update(key => Attribute(key,val)) 
          end
        end
      end
      # and finally set values
      values.each do |key,val|
        if self.class.declared_elements.has_key?(key)
          type = options_for(key)[:type]
          if type
            if val.respond_to?(:each)
              val.each {|v| raise ArgumentError.new("Type is invalid") unless v.is_a?(type)}
            else
              raise ArgumentError.new("Type is invalid") unless val.is_a?(type)
            end
            elements.update(key => type.new(key => val)) if type.ancestors.include?(Body)
            elements.update(key => type.new(val, options_for(key))) if type.ancestors.include?(Element)
          else
            elements.update(key => Element(val, options_for(key)))
          end
        end
      end
    end
    
    # Converts object to XML
    def acdc
      xml = Builder::XmlMarkup.new
      attrs = attributes.inject({}){|acc,attr| acc.update(attr[1].to_hash)}
      xml.tag!(tag_name,attrs){ |body|
        elements.sort{|a,b| a[1].sequence <=> b[1].sequence}.each do |key, elem|
          body << elem.acdc
        end
      }
      xml.target!
    end
    
    # Calls #acdc then matches
    def match(pattern)
      acdc.match(pattern)
    end
    
    # The name to use for the tag
    def tag_name
      self.class.to_s.split("::").last
    end
    
    def method_missing(method_id, *args, &block)
      key = method_id.to_s.gsub(/\=/,"").to_sym
      if elements.has_key?(key) or attributes.has_key?(key)
        (method_id.to_s.match(/\=$/)) ? write(method_id, *args, &block) : read(method_id)
      else
        super
      end
    end

    class << self
      def inherited(child)
        child.instance_variable_set('@declared_elements', @declared_elements)
        child.instance_variable_set('@declared_attributes', @declared_attributes)
        child.instance_variable_set('@element_sequence', @element_sequence)
      end
      
      # Declare an Element for this Body
      # Sequence of elements (XML Schema sequence) is taken care of by the order
      # the elements are declared in the class definition.
      #@param [Symbol] name A name to assign the Element (tag name)
      #@param [Class] type A type to use for the element (enforcement)
      #@option options [Boolean] :single False if object is a collection
      #@option options [String] :tag String determining the name to use in the XML tag
      def element(*options)
        name = options.first
        type = options.second || nil unless options.second.is_a?(Hash)
        opts = options.extract_options!
        opts.merge!(:tag => name) if opts[:tag].nil?
        declared_elements.update(name => opts.merge(:type => type, :sequence => next_sequence))
      end
      
      # Declare an attribute for this Body
      def attribute(name, value = nil)
        declared_attributes.update(name => value)
      end
      
      # Returns the Hash list of Elements declared
      def declared_elements 
        @elements ||= {}
        @declared_elements ||= @elements[to_s] ||= {}
      end
      
      # Returns a Hash list of Attributes declared
      def declared_attributes 
        @attributes ||= {}
        @declared_attributes ||= @attributes[to_s] ||= {}
      end
      
      # Converts the XML to a Class object found in the library
      def acdc(xml)
        doc = Hpricot.XML(xml)
        klass = doc.root.name.constantize
        attributes = doc.root.attributes.inject({}){|acc,attr| acc.update(attr[0].to_sym => attr[1])}
        values = doc.root.children.inject({}) do |acc, node|
          name = node.name.underscore.to_sym
          value = value_from_node(node)
          attrs = node.attributes
          acc.merge!({name => value, :attributes => attrs})
        end
        klass.new(values.merge(:attributes => attributes))
      end
      
      private
        def value_from_node(node)
          if node.respond_to?(:children) and node.children
            values = node.children.collect do |child|
              return child.inner_text if child.text?
              instantiate(child)
            end      
            (values.size == 1) ? values.first : values    
          end
        end
      
        def instantiate(node)
          name = node.name
          attrs = node.attributes
          klass = name.constantize
          klass.new(value_from_node(node), :attributes => attrs)
        end
        
        def next_sequence
          @element_sequence ||= 0
          @element_sequence = @element_sequence +=1
        end
    end
    
    private
    
      def options_for(key)
        self.class.declared_elements[key]
      end
      
      def read(method_id)
        if elements.has_key?(method_id)
          elements[method_id].value
        else
          attributes[method_id].value
        end
      end
    
      def write(method_id, *args, &block)
        key = method_id.to_s.gsub(/\=$/,"").to_sym
        if elements.has_key?(key)
          elements.update(key => Element(args.first, options_for(key)))
        else
          attributes.update(key => Attribute(key,args.first))
        end
      end

  end
end