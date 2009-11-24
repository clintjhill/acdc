require File.join(File.dirname(__FILE__),"spec_helper")

module AcDcSpec
  extend AcDc::Parsing
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
    node = AcDcSpec.acdc(xml_file("parse_spec.xml"))
    node.should be_instance_of(AcDcSpec::ParseSpec)
    node.html.should == 'yep'
    node.body.should == 'Value'
  end
  
  it "should parse lower-case tagged xml" do
    #node = AcDcSpec.acdc(xml_file("lower_case.xml"))
    
  end
  
end