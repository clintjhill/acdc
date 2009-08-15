module AcDc
  
  class Attribute
    
    attr_accessor :name, :value
    
    def initialize(name,value)
      @name = name
      @value = value
    end
    
    def to_hash
      {@name => @value}
    end
    
  end
end