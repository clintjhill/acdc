require File.join(File.dirname(__FILE__),"spec_helper")

module AcDcSpec
  extend AcDc::Parsing
  class ParseSpec
    include AcDc
    namespace "http://schemas.xmlsoap.org/soap/envelope/"
    attribute :html, String
    element :body, String
  end
end

describe AcDc::Parsing do
  
  it "should parse" do
    node = AcDcSpec.acdc(xml_file("parse_spec.xml"))
    node.should be_instance_of(AcDcSpec::ParseSpec)
    node.html.should == 'yep'
    node.body.should == 'Value'
  end
  
end