require '../test/test_helper'

class ApiTest < Test::Unit::TestCase
  def setup

    WebMock.setup

    Seoshop.configure do |conf|
      conf.app_key = 'app_key'
      conf.secret = 'secret'
    end

    @shop_api = Seoshop.client('shop_token', 'shop_language')
    @shop_api.get_orders
    @shop_api.get_shop
  end


  def test_should_return_orders
    assert_nothing_raised do
      orders = @shop_api.get_orders
      assert_equal [] , orders
    end
  end
end