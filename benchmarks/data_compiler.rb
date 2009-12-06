# Creates a large file with a simple schema (roughly 2MB in size)
require 'rubygems'
require 'builder'

DATA_FILE = File.join(File.dirname(__FILE__),"data_file.xml")
XML = Builder::XmlMarkup.new(:indent => 2)
XML.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

XML.tag!("lightning"){ |body|
  20000.times{ |thunder| 
    body.tag!("thunder", :index => thunder){ |t|
      t.claps "Hells Bells"
      t.booms "For those about to rock"
    }
  }
}

File.open(DATA_FILE,"wb") { |file| file.write XML.target! }