module AcDc
  module Parsing
    
    def acdc(xml, options={})
      
      if xml.is_a?(XML::Node)
        node = xml
      else
        if xml.is_a?(XML::Document)
          node = xml.root
        else
          node = XML::Parser.string(xml).parse.root
        end
      end
      
      klass = constantize(node.name)
      
      root = node.name.downcase == klass.tag_name
      
      namespace = node.namespaces.default
      namespace = "#{DEFAULT_NAMESPACE}:#{namespace}" if namespace
      
      xpath = root ? '/' : './/'
      xpath += "#{DEFAULT_NAMESPACE}:" if namespace
      xpath += node.name
      
      nodes = node.find(xpath, Array(namespace))
      
      collection = nodes.collect do |n|
        obj = klass.new
        klass.attributes.each do |attr|
          obj.send("#{attr.method_name}=", attr.value_from_xml(n, namespace))
        end
        klass.elements.each do |elem|
          obj.send("#{elem.method_name}=", elem.value_from_xml(n, namespace))
        end
        obj
      end
      
      nodes = nil
      
      if options[:single] || root
        collection.first
      else
        collection
      end
    end
    
    private
      
      def constantize(type)
        if type.is_a?(String)
          constant = Object
          all_class_names.each do |name|
            if name.downcase == type.downcase
              constant = const_get(name)
            end
          end
          constant
        else
          type
        end
      end
    
  end
end

class Module
  
  def hierarchy
    name.split('::').inject([Object]) {|hierarchy,name|
      hierarchy << hierarchy.last.const_get(name)
    }
  end
  
  def all_class_names
    class_names = []
    constants.each do |const|
      constant = const_get(const)
      case constant
      when Class
        class_names << constant.to_s.split('::',2)[1]
      when Module
        class_names += constant.all_class_names
      end
    end
    class_names.uniq
  end
  
end