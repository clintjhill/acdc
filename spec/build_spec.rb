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
    element :second, String
    element :third, SubBuildTest
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
  
end