require File.join(File.dirname(__FILE__),"spec_helper")

describe AcDc::Element do
  
  before do
    @element = AcDc::Element.new(:elem, String)
  end
  
  it "should know it's an element" do
    @element.element?.should be_true
  end
  
  it "should know it's not an attribute" do
    @element.attribute?.should be_false
  end
  
end