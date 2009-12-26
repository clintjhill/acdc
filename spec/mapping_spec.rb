require File.join(File.dirname(__FILE__),"spec_helper")

class Ac; include AcDc::Mapping; end
  
describe "Mapping features" do
  
  it "should set attributes to an array" do
    Ac.attributes.should == []
  end
  
  it "should set elements to an array" do
    Ac.elements.should == []
  end
  
  it "should allow adding an attribute" do
    lambda {
      Ac.attribute(:test_attr_add, String)
    }.should change(Ac, :attributes)
  end
  
  it "should allow adding an element" do
    lambda {
      Ac.element(:test_elem_add, String)
    }.should change(Ac, :elements)
  end
  
  it "should default tag name to class" do
    Ac.tag_name.should == 'ac'
  end
  
  it "should allow setting tag name" do
    Ac.tag_name('changed')
    Ac.tag_name.should == 'changed'
  end
  
  it "should prevent confusion between same name attr/element" do
    Ac.attribute(:already_there, String)
    Ac.element(:already_there, String)
    Ac.new.should respond_to(:element_already_there)
  end
  
  it "should allow mapping of collections" do
    Ac.element(:coll, String, :single => false)
    ac = Ac.new
    ac.coll = ["test 1","test 2"]
    ac.coll.should be_instance_of(Array)
  end
  
end