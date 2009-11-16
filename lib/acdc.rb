require 'date'
require 'time'
require 'rubygems'
gem 'libxml-ruby', '= 1.1.3'
require 'xml'
gem 'builder'
require 'builder'

class Boolean; end

module AcDc
  
  DEFAULT_NAMESPACE = "example" unless defined?(AcDc::DEFAULT_NAMESPACE)
  VERSION = [0,5,0] unless defined?(AcDc::VERSION)
  
  if defined?(JAIL_BREAK)
    puts "AcDc is live -- Dirty Deeds!"
  end

  def self.included(base)
    base.instance_variable_set("@attributes",{})
    base.instance_variable_set("@elements",{})
    base.extend(ClassMethods)
    base.extend(Parsing)
  end
  
  module ClassMethods
    
    def attributes
      @attributes[to_s] || []
    end

    def elements
      @elements[to_s] || []
    end  
    
    def attribute(name, type, options={})
      attribute = Attribute.new(name,type,options)
      @attributes[to_s] ||= []
      @attributes[to_s] << attribute
      attr_accessor attribute.method_name.intern
    end
    
    def element(name, type, options={})
      element = Element.new(name,type,options)
      @elements[to_s] ||= []
      @elements[to_s] << element
      attr_accessor element.method_name.intern
    end
    
    def tag_name(name = nil)
      @tag_name = name.to_s if name
      @tag_name ||= to_s.split('::')[-1].downcase
    end

    def namespace(namespace = nil)
      @namespace = namespace if namespace
      @namespace
    end
    
  end
  
end
require File.join(File.dirname(__FILE__), 'acdc/build')
require File.join(File.dirname(__FILE__), 'acdc/parse')
require File.join(File.dirname(__FILE__), 'acdc/item')
require File.join(File.dirname(__FILE__), 'acdc/attribute')
require File.join(File.dirname(__FILE__), 'acdc/element')
require File.join(File.dirname(__FILE__), 'acdc/body')