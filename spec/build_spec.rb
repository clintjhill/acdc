require File.join(File.dirname(__FILE__),"spec_helper")

module AcDcBuild
  class SubBuildTest
    include AcDc::Mapping
    include AcDc::Building
    namespace "notperfect.org"
    element :sub_first, String
  end
  class BuildTest
    include AcDc::Mapping
    include AcDc::Building
    element :first, String
    element :second, String, :render_empty => false
    element :third, SubBuildTest, :render_empty => true
  end
end

describe AcDc::Building do
  
  it "should render proper xml for class" do
    bt = AcDcBuild::BuildTest.new
    bt.first = "First Element"
    bt.second = "Second Element"
    bt.third = AcDcBuild::SubBuildTest.new
    bt.third.sub_first = "Third Element"
    xml = bt.acdc
    xml.should match(/<first>First Element<\/first>/)
    xml.should match(/<second>Second Element<\/second>/)
    xml.should match(/<subbuildtest[\s\w\S]*><sub_first>Third Element<\/sub_first><\/subbuildtest>/)
  end
  
  it "should respect render empty" do
    bt = AcDcBuild::BuildTest.new
    bt.first = "Render First"
    xml = bt.acdc
    xml.should match(/<first>Render First<\/first>/)
    xml.should_not match(/<second\s*\/>/)
    xml.should match(/<subbuildtest\s*\/>/)
  end
  
  it "should render collection (native type)" do
    class AcNative < AcDc::Body; element :native, String, :single => false; end;
    nat = AcNative.new
    nat.native = ["Test 1", "Test 2"]
    nat.acdc.should match(/Test 1<\/native><native>Test 2/)
  end
  
  it "should render collection (custom type)" do
    class AcCustom < AcDc::Body; element :child, String; end;
    class AcCustomHolder < AcDc::Body; element :children, AcCustom, :single => false; end;
    ach = AcCustomHolder.new
    ach.children = [AcCustom.new, AcCustom.new]
    ach.acdc.should match(/<accustom><child\/><\/accustom><accustom><child\/><\/accustom>/)
  end
  
  class AlertMessage < AcDc::Body
    tag_name 'AlertMessage'
    attribute :type,    String, :tag => 'Type', :render_empty => false
    element   :message, String, :tag => 'Message', :render_empty => false
    element   :message2, String, :tag => 'Message2', :render_empty => false
  end
  
  it "should not render empty elements from acdc'd xml if marked render_empty" do
    message = '<AlertMessage Type="Legal"></AlertMessage>'
    am = AlertMessage.acdc message
    am.acdc.should_not match(/<Message><\/Message>/)
    am.acdc.should_not match(/<Message2><\/Message2/)
  end
  
  class ValueBody < AcDc::Body
    tag_name 'ValueMessage'
    attribute :type,    String, :tag => 'Type'
  end
  it "should render value of element/body if available" do
    message = '<ValueMessage Type="Legal">Your going to Jail.</ValueMessage>'
    am = ValueBody.acdc message
    am.acdc.should match(/>Your going to Jail.<\//)
  end
  
end