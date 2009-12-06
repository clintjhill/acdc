require 'benchmark'
require File.join(File.dirname(__FILE__), '..', 'lib', 'acdc')

class Thunder < AcDc::Body
  element :claps, String
  element :booms, String
end

class Lightning < AcDc::Body
  element :thunder, Thunder
end

Benchmark.bm do |x|
  x.report("parse") { acdc(File.read("data_file.xml"))}
end