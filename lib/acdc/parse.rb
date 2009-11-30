module AcDc
  module Parsing

    def acdc(xml)
      if xml.is_a?(XML::Node)
        node = xml
      else
        if xml.is_a?(XML::Document)
          node = xml.root
        else
          node = XML::Parser.string(xml).parse.root
        end
      end
      klass = AcDc.parseable_constants.detect{ |const|
        const.name.downcase =~ /#{node.name.downcase}/ || const.tag_name == node.name
      }
      if klass.nil?
        raise Exception.new("Uh Oh ... Live Wire! Couldn't parse #{node.name}.")
      end
      root = node.name.downcase == klass.tag_name.downcase
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
      if root
        collection.first
      else
        collection
      end
    end
       
  end
end