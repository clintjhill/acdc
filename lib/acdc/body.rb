module AcDc
  class Body
    
    include(Mapping)
    include(Building)
    
    def self.inherited(child)
      attrs = @attributes.nil? ? {} : @attributes.dup
      child.instance_variable_set("@attributes", attrs)
      elems = @elements.nil? ? {} : @elements.dup
      child.instance_variable_set("@elements", elems)
      @inheritance_chain ||= []
      @inheritance_chain << child
    end    
      
  end
end