require File.join(File.dirname(__FILE__),"spec_helper")

describe Body do
  
  class TestType < Element; end
  
  class Test < Body
    attribute :test_attr
    element :test_element, TestType
  end
    
  class TestInherit < Test
    attribute :test_inherit_attr
    element :test_inherit_element
  end
  
  it "should validate type if provided" do
    lambda {
      Test.new(:test_element => "Junk")
    }.should raise_error
  end
  
  it "should have it's own separate element values" do
    first = Test.new(:attributes => {:test_attr => "First Attr"}, :test_element => TestType.new("First"))
    second = Test.new(:attributes => {:test_attr => "Second Attr"}, :test_element => TestType.new("Second"))
    first.acdc.should_not eql(second.acdc)
  end
  
  it "should consolidate declared elements when inherited" do
    TestInherit.should have(2).declared_elements
    TestInherit.declared_elements.should include(:test_element)
  end
  
  it "should consolidate declared attributes when inherited" do
    TestInherit.should have(2).declared_attributes
    TestInherit.declared_attributes.should include(:test_attr)
  end
  
  it "should write/read the value of nested declared elements" do
    test = Test.new(:attributes => {:test_attr => "Test Attr"}, :test_element => TestType.new("Test Elem"))
    test.test_element.should eql(TestType.new("Test Elem"))
    changed = Element("Changed")
    test.test_element = changed
    test.test_element.should eql(changed)
    test.test_element = "Changed Again"
    test.test_element.should eql("Changed Again")
  end
  
  it "should read the value of each declared attribute" do
    test = Test.new(:attributes => {:test_attr => "Test Attr"}, :test_element => TestType.new("Test Elem"))
    test.test_attr.should eql("Test Attr")
  end
  
  it "should parse and hydrate from xml" do
    xml = "<Test test_attr=\"Attribute_Test\"><TestElement><TestType><Element>Element_Test1</Element></TestType><TestType>Element_Test2</TestType></TestElement></Test>"
    test = acdc(xml)
    test.should be_instance_of(Test)
    test.test_attr.should eql("Attribute_Test")
    test.test_element.should have(2).items
    test.test_element[0].should be_instance_of(TestType)
    test.test_element[0].should eql(TestType.new(Element("Element_Test1")))
    test.test_element[1].should be_instance_of(TestType)
    test.test_element[1].should eql(TestType.new("Element_Test2"))
  end
  
end