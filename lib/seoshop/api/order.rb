module Seoshop
  module Order
    def get_orders(params = {})
      get("#{@shop_language}/orders.json", params)['orders']
    end

    def get_orders_count
      get("#{@shop_language}/orders/count.json")['count']
    end

    def get_order(order_id)
      get("#{@shop_language}/orders/#{order_id}.json")['order']
    end

    def get_order_products(order_id)
      get("#{@shop_language}/orders/#{order_id}/products.json")['order_products']
    end
  end
end
