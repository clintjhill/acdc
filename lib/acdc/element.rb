module AcDc
  class Element
    
    attr_accessor :value, :tag, :attributes, :options
    
    def initialize(value, options={}, tag=nil)
      @tag = tag ||= self.class.to_s.split("::").last
      @value = value
      @options = options
      @attributes = options.delete(:attributes)
    end
    
    def acdc
      xml = Builder::XmlMarkup.new
      if value.nil?
        xml.tag!(tag_content)
      else
        has_many? ? render_many(xml) : xml.tag!(tag_content) {|elem| elem << content}
      end
      xml.target!
    end
    
    def has_many?
      options.has_key?(:single) and !options[:single] and value.size > 1
    end
    
    def tag_name
      tag.to_s.camelize
    end
    
    def eql?(other)
      return false if other.nil?
      return false unless other.kind_of?(self.class)
      value.eql?(other.value)
    end
    
    private
      def tag_content
        (attributes.nil? or attributes.empty?) ? tag_name : [tag_name,attributes]
      end
      
      def content
        if has_many?
          value.inject(""){|xml,val| xml << (val.is_a?(Element) ? val.acdc : val.to_s)}
        else
          value.is_a?(Element) ? value.acdc : value.to_s
        end
      end
      
      def render_many(xml)
        if value.respond_to?(:each)
          xml.tag!(tag_content){|elem|
            value.each{|val| 
              raise Exception.new("Can't render non-Element multiple times.") unless val.respond_to?(:acdc)
              elem << val.acdc
            }
          }
        else
          xml.tag!(tag_content) {|elem| elem << content}
        end
      end
  end
end