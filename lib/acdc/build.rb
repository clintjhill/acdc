module AcDc
  module Build
    module ClassMethods
      
      # Converts object to XML
      # Very poor support for multiple namespaces
      def acdc(root = true)
        xml = Builder::XmlMarkup.new
        attrs = self.class.attributes.inject({}){ |acc,attr| 
          acc.update(attr.method_name => send(attr.method_name.to_sym))
        }
        attrs.update(:xmlns => self.class.namespace) if self.class.namespace
        xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" if root
        xml.tag!(self.class.tag_name,attrs){ |body|
          self.class.elements.each do |elem|
            value = send(elem.method_name.to_sym)
            if elem.primitive?
              body.tag! elem.method_name, value if value
            else
              body << value.acdc(false) if value
            end
          end
        }
        xml.target!
      end
    end
  end
  
  include Build::ClassMethods
  
end