module AcDc
  class Body 
    
    attr_accessor :attributes, :elements
    
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
            elements.update(key => type.new(val,options_for(key),key))
          else
            elements.update(key => Element(val,options_for(key),key))
          end
        end
      end
    end
  
    def acdc
      xml = Builder::XmlMarkup.new
      attrs = attributes.inject({}){|acc,attr| acc.update(attr[1].to_hash)}
      xml.tag!(tag_name,attrs){ |body|
        elements.each do |key, elem|
          body << elem.acdc
        end
      }
      xml.target!
    end
  
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
        child.instance_variable_set('@elements',@elements ||= {})
        child.instance_variable_set('@attributes',@attributes ||= {})
      end
      
      def element(*options)
        @elements ||= {}
        name = options.first
        type = options.second || nil
        opts = options.extract_options!
        @elements.update(name => opts.merge(:type => type))
      end
      
      def attribute(name, value = nil)
        @attributes ||= {}
        @attributes.update(name => value)
      end
      
      def declared_elements 
        @elements
      end
      
      def declared_attributes 
        @attributes
      end
      
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
          elements.update(key => Element(args.first,options_for(key),key))
        else
          attributes.update(key => Attribute(key,args.first))
        end
      end

  end
end