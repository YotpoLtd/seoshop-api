require 'rubygems'
require 'test/unit'

Dir['../test/*.rb'].each {|file| require file }
Dir['../lib/*.rb'].each {|file| require file }

class Test::Unit::TestCase
  include WebMock

  def self.load_fixture(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}.xml")
  end
end

