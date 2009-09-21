require File.join(File.dirname(__FILE__),"spec_helper")

describe AcDc::Attribute do
  it "should convert to hash" do
    attr = Attribute(:tag,"value")
    attr.to_hash.should have_key(:tag)
    attr.to_hash.should have_value("value")
  end
end