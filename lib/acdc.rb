require 'rubygems'
require 'builder'
require 'activesupport'
require 'hpricot'
                                          
require File.join(File.dirname(__FILE__),"acdc","attribute")
require File.join(File.dirname(__FILE__),"acdc","element")
require File.join(File.dirname(__FILE__),"acdc","body")

module AcDc
  
  VERSION = [0,1,0] unless defined?(AcDc::VERSION)
  
  if defined?(JAIL_BREAK)
    Element.class_eval{ alias :to_s :acdc }
    Body.class_eval{ alias :to_s :acdc }
  end
  
end

include AcDc

# Will construct a AcDc::Element classs
def Element(value, options = {}, name = nil)
  Element.new(value,options,name)
end

# Will construct a AcDc::Attribute class
def Attribute(name,value)
  Attribute.new(name,value)
end

# Will convert the XML to a class found in the library
def acdc(xml)
  Body.acdc(xml)
end

