module Seoshop
  module Customer
    def get_customers(params = {})
      get("#{@shop_language}/customers.json", params)['customers']
    end

    def get_customers_count
      get("#{@shop_language}/customers/count.json")['count']
    end

    def get_customer(customer_id)
      get("#{@shop_language}/customers/#{customer_id}.json")['customer']
    end
  end
end
