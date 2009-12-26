module AcDc
  class Item 
    
    Types = [String, Float, Time, Date, DateTime, Integer, Boolean]
    attr_accessor :name, :type, :tag, :options, :namespace
    
    def initialize(name, type, options={})
      @name = name.to_s
      @type = type
      @renderable = options.delete(:render_empty)
      @renderable = true if @renderable.nil?
      @tag = options.delete(:tag) || 
             @type.tag_name rescue nil ||
             name.to_s
      @options = options
      @xml_type = self.class.to_s.split('::').last.downcase
    end
    
    def renderable?
      @renderable
    end
    
    def method_name
      @method_name ||= name.tr('-','_')
    end
    
    def constant
      @constant ||= constantize(type)
    end
    
    def single?
      options[:single].nil? || options[:single]
    end
    
    def element?
      @xml_type == 'element'
    end
    
    def attribute?
      !element?
    end
    
    def value_from_xml(node, namespace)
      find(node,namespace) do |n|
        if primitive?
          value = n.respond_to?(:content) ? n.content : n.to_s
          typecast(value)
        else
          # it is important to "detach" the node from the document
          # by passing it in as a string. this forces the root xpath
          # lookup to work properly.
          constant.acdc(n.to_s)
        end
      end
    end
    
    def primitive?
      Types.include?(constant)
    end
    
    def xpath(namespace = self.namespace)
      xpath  = ''
      xpath += "#{DEFAULT_NAMESPACE}:" if namespace
      xpath += tag
      xpath
    end
    
    private
      def constantize(type)
        if type.is_a?(String)
          names = type.split('::')
          constant = Object
          names.each do |name|
            constant =  constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
          end
          constant
        else
          type
        end
      end
      
      def find(node, namespace, &block)
        if options[:namespace] == false
          namespace = nil
        elsif options[:namespace]
          namespace = "#{DEFAULT_NAMESPACE}:#{options[:namespace]}"
        elsif self.namespace
          namespace = "#{DEFAULT_NAMESPACE}:#{self.namespace}"
        end
        if element?
          if(single?)
            
            result = node.find_first(xpath(namespace), namespace)

            if result.nil? and AcDc::parseable_constants.include?(@type)
             # This makes sure it is found if in the event the Ruby type name
             # doesn't match the Xml node name, but the type has a tag_name.
             # Not sure why this would be good ---- edge case fix.
             result = node.find_first(@type.tag_name, namespace)
            end
            
            if result.nil? 
             # This makes sure it is found in the event the Ruby method name
             # doesn't match the Xml node name.
             # Not sure why this would be good ---- edge case fix.
             result = node.find_first(@type.to_s.split('::').last, namespace)
            end
          
          else
            result = node.find(xpath(namespace))
          end
          if result
            if(single?)
              value = yield(result)
            else
              value = []
              result.each do |res|
                value << yield(res)
              end
            end
            value
          else
            nil
          end
        else
          yield(node[tag])
        end
      end
      
      def typecast(value)
        return value if value.kind_of?(constant) || value.nil?
        begin        
          if    constant == String    then value.to_s
          elsif constant == Float     then value.to_f
          elsif constant == Time      then Time.parse(value.to_s)
          elsif constant == Date      then Date.parse(value.to_s)
          elsif constant == DateTime  then DateTime.parse(value.to_s)
          elsif constant == Boolean   then ['true', 't', '1'].include?(value.to_s.downcase)
          elsif constant == Integer
            value_to_i = value.to_i
            if value_to_i == 0 && value != '0'
              value_to_s = value.to_s
              begin
                Integer(value_to_s =~ /^(\d+)/ ? $1 : value_to_s)
              rescue ArgumentError
                nil
              end
            else
              value_to_i
            end
          else
            value
          end
        rescue
          value
        end
      end
  end
end