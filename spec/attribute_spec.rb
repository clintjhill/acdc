require File.join(File.dirname(__FILE__),"spec_helper")

describe AcDc::Attribute do

  before do
    @attr = AcDc::Attribute.new(:attr, String)
  end
  
  it "should know it's an attribute" do
    @attr.attribute?.should be_true
  end
  
  it "should know it's not an element" do
    @attr.element?.should be_false
  end
  
end
