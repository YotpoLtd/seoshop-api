module Seoshop
  module Product
    def get_products(params = {})
      response = get("#{@shop_language}/products.json", params)
      response.body ? response.body['products'] : false
    end

    def get_products_count
      response = get("#{@shop_language}/products/count.json")
      response.body ? response.body['count'] : false
    end

    def get_product(product_id)
      response = get("#{@shop_language}/products/#{product_id}.json")
      response.body ? response.body['product'] : false
    end
  end
end
