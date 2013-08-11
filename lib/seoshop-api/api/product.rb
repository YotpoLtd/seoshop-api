module Seoshop
  module Product
    def get_products(params = {})
      get("#{@shop_language}/products.json", params)['products']
    end

    def get_products_count
      get("#{@shop_language}/products/count.json")['count']
    end

    def get_product(product_id)
      get("#{@shop_language}/products/#{product_id}.json")['product']
    end
  end
end
