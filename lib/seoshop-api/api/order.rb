module Seoshop
  module Order
    def get_orders(params = {})
      response = get("#{@shop_language}/orders.json", params)
      response.body ? response.body['orders'] : false
    end

    def get_orders_count
      response = get("#{@shop_language}/orders/count.json")
      response.body ? response.body['count'] : false
    end

    def get_order(order_id)
      response = get("#{@shop_language}/orders/#{order_id}.json")
      response.body ? response.body['order'] : false
    end

    def get_order_products(order_id)
      response = get("#{@shop_language}/orders/#{order_id}/products.json")
      response.body ? response.body['order_products'] : false
    end
  end
end
