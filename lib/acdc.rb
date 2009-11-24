require 'date'
require 'time'
require 'rubygems'
gem 'libxml-ruby', '= 1.1.3'
require 'xml'
gem 'builder'
require 'builder'

class Boolean; end

module AcDc
  
  DEFAULT_NAMESPACE = "acdc" unless defined?(AcDc::DEFAULT_NAMESPACE)
  VERSION = [0,6,0] unless defined?(AcDc::VERSION)
  
  if defined?(JAIL_BREAK)
    puts "AcDc is live -- Dirty Deeds!"
  end
  
end

require File.join(File.dirname(__FILE__), 'acdc/mapping')
require File.join(File.dirname(__FILE__), 'acdc/build')
require File.join(File.dirname(__FILE__), 'acdc/parse')
require File.join(File.dirname(__FILE__), 'acdc/item')
require File.join(File.dirname(__FILE__), 'acdc/attribute')
require File.join(File.dirname(__FILE__), 'acdc/element')
require File.join(File.dirname(__FILE__), 'acdc/body')