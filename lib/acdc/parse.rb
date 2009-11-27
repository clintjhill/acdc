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
      # This constantize is a global scope constantize.
      # It will use AcDc#parseable_constants to detect which class
      # is being parsed.
      klass = constantize(node.name)
      if klass.nil?
        raise Exception.new("Uh Oh ... Live Wire! Couldn't parse #{node.name}.")
      end
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
      # I'm using a separate store for constants because of the fact at 
      # runtime during parsing we will simply get a tag name to start with.
      # It won't be in a form we could use to detect a constant normally.
      # Also - this way provides a cleaner check for the tag_name feature.
      AcDc.parseable_constants.detect{ |const|
        const.name.downcase =~ /#{type.downcase}/ || const.tag_name == type
      }
    end
       
  end
end