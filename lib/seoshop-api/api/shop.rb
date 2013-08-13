module Seoshop
  module Shop
    def get_shop
      response = get("#{@shop_language}/shop.json")
      response.body ? response.body['shop'] : false
    end

    def get_shop_website
      response = get("#{@shop_language}/shop/website.json")
      response.body ? response.body['shop_website'] : false
    end

    def get_shop_company
      response = get("#{@shop_language}/shop/company.json")
      response.body ? response.body['shop_company'] : false
    end
  end
end

