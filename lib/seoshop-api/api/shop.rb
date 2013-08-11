module Seoshop
  module Shop
    def get_shop
      get("#{@shop_language}/shop.json")['shop']
    end

    def get_shop_website
      get("#{@shop_language}/shop/website.json")['shop_website']
    end

    def get_shop_company
      get("#{@shop_language}/shop/company.json")['shop_company']
    end
  end
end

