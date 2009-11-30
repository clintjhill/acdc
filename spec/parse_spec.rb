require File.join(File.dirname(__FILE__),"spec_helper")

module AcDcSpec
  class ParseSpec
    include AcDc::Mapping
    namespace "http://schemas.xmlsoap.org/soap/envelope/"
    attribute :html, String
    element :body, String
  end
  class Header < AcDc::Body
    element :token, String
  end
  class LowerCase < AcDc::Body
    tag_name "XMLLowerCased"
    element :first, String
    element :head, Header
  end
  class Nested < AcDc::Body
    element :lower, LowerCase
  end
  class Namespaced < AcDc::Body
    namespace "http://example.org"
    element :lower, LowerCase
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
  
  it "should parse nested Element/Body tags" do
    node = acdc(xml_file("nested.xml"))
    node.should be_instance_of(AcDcSpec::Nested)
    node.lower.should be_instance_of(AcDcSpec::LowerCase)
    node.lower.head.should be_instance_of(AcDcSpec::Header)
  end
  
  it "should parse nested namespaced Element/Body tags" do
    node = acdc(xml_file("namespaced.xml"))
    node.should be_instance_of(AcDcSpec::Namespaced)
    node.lower.should be_instance_of(AcDcSpec::LowerCase)
    node.lower.head.should be_instance_of(AcDcSpec::Header)
  end
  
  it "should throw exception to unknown tags" do
    lambda{
      node = acdc("<?xml version='1.0' encoding='UTF-8'?><not><something/></not>")  
    }.should raise_error(/Live Wire!/)
  end
  
end