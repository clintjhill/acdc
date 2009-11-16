require File.join(File.dirname(__FILE__), "spec_helper")

describe AcDc::Item do
  
  before do
    @item = AcDc::Item.new(:bigballs, String, :tag => 'big_balls')
  end
  
  it "should expose a name" do
    @item.name.should == "bigballs"
  end
  
  it "should expose a Type" do
    @item.type.should == String
  end
  
  it "should expose a tag" do
    @item.tag.should == "big_balls"
  end
  
  it "should expose options" do
    @item.options.should be_empty
  end
  
  it "should expose a method name" do
    @item.method_name.should == "bigballs"
  end
  
end

describe "Item#constant" do
  
  it "should convert string type to constant" do
    item = AcDc::Item.new(:fake, 'String')
    item.constant.should == String
  end
  
  it "should convert string with namespace separators to constant" do
    module Ugly; class Duck; end; end
    item = AcDc::Item.new(:fake, 'Ugly::Duck')
    item.constant.should == Ugly::Duck
  end
  
end