module Seoshop
  module Customer
    def get_customers(params = {})
      response = get("#{@shop_language}/customers.json", params)
      response.body ? response.body['customers'] : false
    end

    def get_customers_count
      response = get("#{@shop_language}/customers/count.json")
      response.body ? response.body['count'] : false
    end

    def get_customer(customer_id)
      response = get("#{@shop_language}/customers/#{customer_id}.json")
      response.body ? response.body['customer'] : false
    end
  end
end
