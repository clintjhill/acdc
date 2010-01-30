module AcDc
  module Parsing

    def acdc(xml)
      return nil if xml.nil?
      
      if xml.is_a?(XML::Node)
        node = xml
      else
        if xml.is_a?(XML::Document)
          node = xml.root
        else
          node = XML::Parser.string(xml).parse.root
        end
      end
    
      klass = AcDc.parseable_constants.find{ |const|
        const.name.downcase =~ /#{node.name.downcase}/ || const.tag_name == node.name
      }
      
      if klass.nil?
        raise Exception.new("Uh Oh ... Live Wire! Couldn't parse #{node.name}.")
      end
 
      namespace = node.namespaces.default
      namespace = "#{DEFAULT_NAMESPACE}:#{namespace}" if namespace

      obj = klass.new
      
      klass.attributes.each do |attr|
        obj.send("#{attr.method_name}=", attr.value_from_xml(node, namespace))
      end
      
      if klass.elements.size > 0
        klass.elements.each do |elem|
          obj.send("#{elem.method_name}=", elem.value_from_xml(node, namespace))
        end
      end
      
      if obj.is_a?(AcDc::Body) 
        obj.value = node.respond_to?(:content) ? node.content : node.to_s
      end  
          
      obj 
       
    end
       
  end
end