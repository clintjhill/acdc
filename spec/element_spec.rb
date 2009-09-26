require File.join(File.dirname(__FILE__),"spec_helper")

describe Element do
  
  class Email < Element; end
  class Contact < Element; end

  class Contained < Body
    element :contained_value
  end
  
  email = Email.new("clint_hill@msn.com")
  contact = Contact.new(email)
  
  email_content = "clint_hill@msn.com"
  email_xml = "<Email>clint_hill@msn.com</Email>"
  contact_content = email_xml
  contact_xml = "<Contact>#{email_xml}</Contact>"
  
  it "should have many if specified" do
    many = Element("value",{:single => false})
    many.should have_many
  end
  
  it "should know XML content" do
    contact.send(:content).should eql(email_xml)
  end
  
  it "should know non-XML content" do
    email.send(:content).should eql(email_content)
  end
  
  it "should render XML" do
    email.acdc.should eql(email_xml)
  end
  
  it "should render XML with proper tag" do
    test = Email.new("test", :tag => "email1")
    test.acdc.should match(/<email1>.+<\/email1>/)
  end
  
  it "should render nested Element XML" do
    contact.acdc.should eql(contact_xml)
  end
  
  it "should assure XML renders regardless of containing class type" do
    email = Email.new(Contained.new(:contained_value => "Testing"))
    email.acdc.should match(/<contained_value>/)
  end
  
  it "should render empty XML tag if no value" do
    email = Email.new(nil)
    email.acdc.should match(/Email\/>/)
  end
  
  it "should raise exception to multiple non-elements" do
    many = Element(["test1","test2"],{:single => false})
    lambda{ many.acdc }.should raise_error
  end
  
  it "should render multiple elements" do
    email1 = Email.new("some_email1")
    email2 = Email.new("some_email2")
    many = Element([email1,email2],{:single => false})
    many.acdc.should match(/<Element>(<Email>.*<\/Email>){2}<\/Element>/)
  end
  
  it "should compare content when using eql?" do
    email1 = Email.new("email_test")
    email2 = Email.new("email_test")
    email1.should eql(email2)
  end
  
  it "should compare multiple elements content when using eql?" do
    email1 = Email.new([Element("first"),Element("second")], {:single => false})
    email2 = Email.new([Element("first"),Element("second")], {:single => false})
    email1.should eql(email2)
  end
  
end