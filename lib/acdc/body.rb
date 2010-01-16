module AcDc
  class Body
    
    attr_accessor :value
    
    include Mapping
    include Building
    
    def self.inherited(child)
      attrs = @attributes.nil? ? {} : @attributes.dup
      child.instance_variable_set("@attributes", attrs)
      elems = @elements.nil? ? {} : @elements.dup
      child.instance_variable_set("@elements", elems)
      @inheritance_chain ||= []
      @inheritance_chain << child
      AcDc.parseable_constants << child
    end    
      
  end
end