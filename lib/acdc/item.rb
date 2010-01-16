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
      @single ||= options[:single].nil? || options[:single]
    end
    
    def element?
      @xml_type == 'element'
    end
    
    def attribute?
      !element?
    end
    
    def value_from_xml(node, namespace)
      n = find(node,namespace)
      if primitive?
        value = n.respond_to?(:content) ? n.content : n.to_s
        typecast(value)
      else
        constant.acdc(n)
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
      
      def find(node, namespace)
        if element?
          result = single? ? node.find_first(xpath(namespace), namespace) : node.find(xpath(namespace))
          unless result.nil?
            value = single? ? result : result.each { |res| (value ||= []) << res } 
          end
          value
        else
          node[tag]
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