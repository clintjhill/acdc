require 'rubygems'
require 'builder'
require 'activesupport'
require 'hpricot'
                                          
require File.join(File.dirname(__FILE__),"acdc","attribute")
require File.join(File.dirname(__FILE__),"acdc","element")
require File.join(File.dirname(__FILE__),"acdc","body")

module AcDc
  
  VERSION = [0,2,3] unless defined?(AcDc::VERSION)
  
  if defined?(JAIL_BREAK)
    Element.class_eval{ alias :to_s :acdc }
    Body.class_eval{ alias :to_s :acdc }
  end
  
end

# Will construct a AcDc::Element classs
def Element(value, options = {})
  AcDc::Element.new(value,options)
end

# Will construct a AcDc::Attribute class
def Attribute(name,value)
  AcDc::Attribute.new(name,value)
end

# Will convert the XML to a class found in the library
def acdc(xml)
  AcDc::Body.acdc(xml)
end

