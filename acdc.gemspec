require File.join(File.dirname(__FILE__),"lib","acdc")
include AcDc
Gem::Specification.new do |s|
  s.name = "acdc"
   s.version = AcDc::VERSION
   s.platform = Gem::Platform::RUBY
   s.author = "Clint Hill"
   s.email = "clint.hill@h3osoftware.com"
   s.homepage = "http://h3osoftware.com/acdc"
   s.summary = "AC/DC by h3o(software)"
   s.description = <<-EOF
     This is a little xml-to-object-to-xml library that gets Dirty Deeds Done Dirt Cheap. 
   EOF
   s.rubyforge_project = "acdc"
   s.require_path = "lib"
   s.files        = %w( LICENSE README Rakefile ) + Dir["{spec,lib,doc}/**/*"]
   s.add_dependency "activesupport"
   s.add_dependency "builder"
   s.add_dependency "hpricot"
end