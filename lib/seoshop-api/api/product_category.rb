module Seoshop
  module ProductCategory
    def get_category category_id
      response = get("#{@shop_language}/categories/#{category_id}.json")
      response.body ? response.body['category'] : nil
    end
    def get_product_category_path(product_id)
      response = get("#{@shop_language}/categories/products.json?product=#{product_id}")
      categories_products = response.body ? response.body['categoriesProducts'] : []
      categories_products.map{|category|
        get_category(category.category.resource.id).fulltitle
      }.join(">")
    end

    def get_categories_count
      response = get("#{@shop_language}/categories/products/count.json")
      response.body ? response.body['count'] : false
    end

  end
end
