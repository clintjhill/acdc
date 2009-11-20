require File.join(File.dirname(__FILE__),"spec_helper")

class AcInherited < AcDc::Body; end;
class AcInheritedTwice < AcInherited; end;
class AcSequenced < AcDc::Body
  element :first, String
  element :second, String
  element :third, String
end

describe "Body inherited features" do
    
  it "should set attributes to an array" do
    AcInherited.attributes.should == []
    AcInheritedTwice.attributes.should == []
  end
  
  it "should set elements to an array" do
    AcInherited.elements.should == []
    AcInheritedTwice.elements.should == []
  end
  
  it "should allow adding an attribute" do
    lambda {
      AcInherited.attribute(:name, String)
    }.should change(AcInherited.attributes, :length)
    AcInheritedTwice.attributes.should include(AcInherited.attributes.first)
  end
  
  it "should allow adding an element" do
    lambda {
      AcInherited.element(:name, String)
    }.should change(AcInherited.elements, :length)
    AcInheritedTwice.elements.should include(AcInherited.elements.first)
  end
  
  it "should default tag name to class" do
    AcInherited.tag_name.should == 'acinherited'
    AcInheritedTwice.tag_name.should == 'acinheritedtwice'
  end
  
  it "should allow setting tag name" do
    AcInherited.tag_name('changed')
    AcInherited.tag_name.should == 'changed'
    AcInheritedTwice.tag_name('changedtwice')
    AcInheritedTwice.tag_name.should == 'changedtwice'
  end
  
  it "should responsd to parse" do
    AcInherited.should respond_to(:acdc)
  end
  
end

describe "Body Rendering features" do
  
  it "should respond to acdc per instance" do
    AcInherited.new.should respond_to(:acdc)
  end
  
  it "should prevent confusion between same name attr/element" do
    fail "not implemented"
  end
  
  it "should render appropriately" do
    ac1 = AcInherited.new
    ac1.name = "AcDc Renderererer"
    ac1.acdc.should match(/<changed [\w\S\W]*><name>AcDc Renderererer<\/name><\/changed>/)
  end
  
  it "should render inherited attrs/elems appropriately" do
    ac2 = AcInheritedTwice.new
    ac2.name = "Ac Dc Inherited"
    ac2.acdc.should match(/<changedtwice [\w\S\W]*><name>Ac Dc Inherited<\/name><\/changedtwice>/)
    AcInherited.element(:new_one, String)
    ac2.acdc.should match(/<\/name><new_one\/>/)
  end
  
  it "should render elements in sequence declared" do
    acs = AcSequenced.new
    acs.acdc.should match(/<first\/><second\/><third\/>/)
  end
  
end
