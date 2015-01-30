module Seoshop
  module Brand
    def get_brand(brand_id)
      response = get("#{@shop_language}/brands/#{product_id}.json")
      response.body ? response.body['brand'] : false
    end
  end
end
