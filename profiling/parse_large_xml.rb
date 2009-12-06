require 'rubygems'
gem 'ruby-prof'
require 'ruby-prof'
require File.join(File.dirname(__FILE__), '..', 'lib', 'acdc')

class Thunder < AcDc::Body
  element :claps, String
  element :booms, String
end

class Lightning < AcDc::Body
  element :thunder, Thunder
end

RubyProf.start
acdc(File.read(File.join(File.dirname(__FILE__),"..","benchmarks","data_file.xml")))
result = RubyProf.stop
printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT, 0)
