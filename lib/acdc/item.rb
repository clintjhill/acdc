module AcDc
  class Item 
    
    Types = [String, Float, Time, Date, DateTime, Integer, Boolean]
    attr_accessor :name, :type, :tag, :options, :namespace
    
    def initialize(name, type, options={})
      @name = name.to_s
      @type = type
      @tag = options.delete(:tag) || name.to_s
      @options = options
      @xml_type = self.class.to_s.split('::').last.downcase
    end
    
    def method_name
      @method_name ||= name.tr('-','_')
    end
    
    def constant
      @constant ||= constantize(type)
    end
    
    def element?
      @xml_type == 'element'
    end
    
    def attribute?
      !element?
    end
    
    def value_from_xml(node, namespace)
      if primitive?
        find(node, namespace) do |n|
          value = n.respond_to?(:content) ? n.content : n.to_s
          typecast(value)
        end
      else
        constant.parse(node, options)
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
          if(options[:single].nil? || options[:single])
            result = node.find_first(xpath(namespace), namespace)
          else
            result = node.find(xpath(namespace))
          end
         
          if result
            if(options[:single].nil? || options[:single])
              value = yield(result)
            else
              value = []
              result.each do |res|
                value << yield(res)
              end
            end
            if options[:attributes].is_a?(Hash)
              result.attributes.each do |xml_attribute|
                if attribute_options = options[:attributes][xml_attribute.name.to_sym]
                  attribute_value = Attribute.new(xml_attribute.name.to_sym, *attribute_options).from_xml_node(result, namespace)
                  result.instance_eval <<-EOV
                    def value.#{xml_attribute.name}
                      #{attribute_value.inspect}
                    end
                  EOV
                end
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