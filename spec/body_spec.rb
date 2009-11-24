require File.join(File.dirname(__FILE__),"spec_helper")

class AcInherited < AcDc::Body; end;
class AcInheritedTwice < AcInherited; end;
class AcSequenced < AcDc::Body
  element :first, String
  element :second, String
  element :third, String
end

describe "Body inherited features" do
  
  it "should inherit attribute" do
    AcInherited.attribute(:test_attr_add, String)
    AcInheritedTwice.attributes.first.method_name.should == AcInherited.attributes.first.method_name
  end
  
  it "should inherit element" do
    AcInherited.element(:test_elem_add, String)
    AcInheritedTwice.elements.first.method_name.should == AcInherited.elements.first.method_name
  end
  
end

describe "Body Rendering features" do
  
  it "should respond to acdc per instance" do
    AcInherited.new.should respond_to(:acdc)
  end
  
  it "should render appropriately" do
    AcInherited.element(:name, String)
    ac1 = AcInherited.new
    ac1.name = "AcDc Renderererer"
    ac1.acdc.should match(/<acinherited [\w\S\W]*><name>AcDc Renderererer<\/name><\/acinherited>/)
  end
  
  it "should render inherited attrs/elems appropriately" do
    ac2 = AcInheritedTwice.new
    ac2.name = "Ac Dc Inherited"
    ac2.acdc.should match(/<acinheritedtwice [\w\S\W]*><name>Ac Dc Inherited<\/name><\/acinheritedtwice>/)
    AcInherited.element(:new_one, String)
    ac2.acdc.should match(/<\/name><new_one\/>/)
  end
  
  it "should render elements in sequence declared" do
    acs = AcSequenced.new
    acs.acdc.should match(/<first\/><second\/><third\/>/)
  end
  
end
