Gem::Specification.new do |s|
    s.name = %q{acdc}
    s.version = "0.1.1"

    s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
    s.authors = ["Clint Hill"]
    s.date = %q{2009-09-19}
    s.description = %q{This is a little xml-to-object-to-xml library that gets Dirty Deeds Done Dirt Cheap.}
    s.email = %q{clint.hill@h3osoftware.com}
    s.files = [
       "LICENSE",
       "README",
       "Rakefile",
       "lib/acdc.rb",
       "lib/acdc/attribute.rb",
       "lib/acdc/body.rb",
       "lib/acdc/element.rb"
    ]
    s.homepage = %q{http://github.com/clinth3o/acdc}
    s.require_paths = ["lib"]
    s.rubygems_version = %q{1.3.4}
    s.summary = %q{This is a little xml-to-object-to-xml library that gets Dirty Deeds Done Dirt Cheap.}

    if s.respond_to? :specification_version then
      current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
      s.specification_version = 3

      if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
        s.add_runtime_dependency(%q<activesupport>, [">= 2.3.2"])
        s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
        s.add_runtime_dependency(%q<hpricot>, [">= 0.8"])
      else
        s.add_dependency(%q<activesupport>, [">= 2.3.2"])
        s.add_dependency(%q<builder>, [">= 2.1.2"])
        s.add_dependency(%q<hpricot>, [">= 0.8"])
      end
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<hpricot>, [">= 0.8"])
    end
  end