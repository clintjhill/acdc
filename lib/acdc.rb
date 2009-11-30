require 'date'
require 'time'
require 'rubygems'
gem 'libxml-ruby', '= 1.1.3'
require 'xml'
gem 'builder'
require 'builder'

class Boolean; end

module AcDc
  
  DEFAULT_NAMESPACE = "acdc"
  VERSION = [0,7,2]
  
  def self.parseable_constants
    @parseables ||= []
  end
  
end

dir = File.dirname(__FILE__) 
require File.join(dir, 'acdc/mapping')
require File.join(dir, 'acdc/build')
require File.join(dir, 'acdc/parse')
require File.join(dir, 'acdc/item')
require File.join(dir, 'acdc/attribute')
require File.join(dir, 'acdc/element')
require File.join(dir, 'acdc/body')

class Object
  include AcDc::Parsing
end