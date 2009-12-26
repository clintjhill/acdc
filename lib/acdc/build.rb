module AcDc
  module Building
    
    # Converts object to XML
    # Very poor support for multiple namespaces
    def acdc(root = true)
      xml = Builder::XmlMarkup.new
      attrs = self.class.attributes.inject({}){ |acc,attr| 
        acc.update(attr.tag => send(attr.method_name.to_sym))
      }
      attrs.update(:xmlns => self.class.namespace) if self.class.namespace
      xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" if root
      xml.tag!(self.class.tag_name,attrs){ |body|
        self.class.elements.each do |elem|
          value = send(elem.method_name.to_sym)
          if value
            if elem.single?
              if elem.primitive?
                body.tag! elem.tag, value 
              else
                body << value.acdc(false)
              end
            else
              value.each { |v|
                if v.kind_of?(AcDc::Body)
                  body << v.acdc(false)
                else
                  body.tag! elem.tag, v
                end
              }
            end
          else
            body.tag! elem.tag if elem.renderable?
          end
        end
      }
      xml.target!
    end

  end  
end