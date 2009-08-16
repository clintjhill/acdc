module AcDc
  
  # Attribute object used in Element and Body.
  # Not often used outside of these.
  class Attribute
    
    attr_accessor :name, :value
    
    def initialize(name,value)
      @name = name
      @value = value
    end
    
    # Returns the values of this attribute in hash form
    def to_hash
      {@name => @value}
    end
    
  end
end