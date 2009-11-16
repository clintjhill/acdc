require File.join(File.dirname(__FILE__),"spec_helper")

describe "AcDc include features" do
  
  before do
    class Ac; include AcDc; end
  end
  
  it "should set attributes to an array" do
    Ac.attributes.should == []
  end
  
  it "should set elements to an array" do
    Ac.elements.should == []
  end
  
  it "should allow adding an attribute" do
    lambda {
      Ac.attribute(:name, String)
    }.should change(Ac, :attributes)
  end
  
  it "should allow adding an element" do
    lambda {
      Ac.element(:name, String)
    }.should change(Ac, :elements)
  end
  
  it "should default tag name to class" do
    Ac.tag_name.should == 'ac'
  end
  
  it "should allow setting tag name" do
    Ac.tag_name('changed')
    Ac.tag_name.should == 'changed'
  end
  
  it "should respond to acdc for parsing" do
    Ac.should respond_to(:acdc)
  end
  
end