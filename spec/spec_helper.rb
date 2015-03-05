require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'pry'
require 'rspec'

require './lib/seoshop-api'

RSpec.configure do |config|

  config.before(:each) do
    Seoshop.configure do |conf|
      conf.app_key = 'app_key'
      conf.secret = 'secret'
    end
  end
end
