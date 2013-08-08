require 'webmock/test_unit'

module WebMock
  def self.setup
    seoshop_api_url = 'https://api.webshopapp.com'
    #fixtures_path = File.expand_path(Dir.pwd) + '/fixtures/'


    #re = Regexp.union([/((?!shop_token)\s)*/])
    stub_request(:post, "#{seoshop_api_url}/shop_language/shop.json").to_return(:body => ApiTest.load_fixture('invalid_token'))

  end
end