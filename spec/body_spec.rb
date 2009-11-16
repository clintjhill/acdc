require File.join(File.dirname(__FILE__),"spec_helper")

describe "Body inherited features" do
  
  before do
    class AcInherited < AcDc::Body; end;
  end
  
  it "should set attributes to an array" do
    AcInherited.attributes.should == []
  end
  
  it "should set elements to an array" do
    AcInherited.elements.should == []
  end
  
  it "should allow adding an attribute" do
    lambda {
      AcInherited.attribute(:name, String)
    }.should change(AcInherited, :attributes)
  end
  
  it "should allow adding an element" do
    lambda {
      AcInherited.element(:name, String)
    }.should change(AcInherited, :elements)
  end
  
  it "should default tag name to class" do
    AcInherited.tag_name.should == 'acinherited'
  end
  
  it "should allow setting tag name" do
    AcInherited.tag_name('changed')
    AcInherited.tag_name.should == 'changed'
  end
  
  it "should responsd to parse" do
    AcInherited.should respond_to(:acdc)
  end
  
end