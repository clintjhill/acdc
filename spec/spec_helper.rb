require File.join(File.dirname(__FILE__),"..", "lib","acdc")
require 'spec'

def xml_file(filename)
  File.read(File.dirname(__FILE__) + "/xml/#{filename}")
end