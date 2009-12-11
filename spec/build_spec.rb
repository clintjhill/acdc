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
  
end