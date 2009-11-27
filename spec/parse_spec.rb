require File.join(File.dirname(__FILE__),"spec_helper")

module AcDcSpec
  class ParseSpec
    include AcDc::Mapping
    namespace "http://schemas.xmlsoap.org/soap/envelope/"
    attribute :html, String
    element :body, String
  end
  class LowerCase < AcDc::Body
    tag_name :lower_case
    element :first, String
  end
end

describe AcDc::Parsing do
  
  it "should parse non-special xml" do
    node = acdc(xml_file("parse_spec.xml"))
    node.should be_instance_of(AcDcSpec::ParseSpec)
    node.html.should == 'yep'
    node.body.should == 'Value'
  end
  
  it "should parse through tag_name" do
    node = acdc(xml_file("lower_case.xml"))
    node.should be_instance_of(AcDcSpec::LowerCase)
  end
  
  it "should throw exception to unknown tags" do
    lambda{
      node = acdc("<?xml version='1.0' encoding='UTF-8'?><not><something/></not>")  
    }.should raise_error(/Live Wire!/)
  end
  
end