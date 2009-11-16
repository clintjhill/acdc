module AcDc
  class Body
    def self.inherited(child)
      child.instance_variable_set("@attributes", {})
      child.instance_variable_set("@elements",{})
    end
    extend(ClassMethods)
    extend(Parsing)
  end
end