module Seoshop
  module ShopScript

    def get_scripts(params = {})
      response = get("#{@shop_language}/shop/scripts.json", params)
      response.body ? response.body['scripts'] : false
    end

    # def post_script(params)
    #   response = get("#{@shop_language}/products/count.json")
    #   response.body ? response.body['count'] : false
    # end

    # def update_script(script_id, product_id)
    #   response = get("#{@shop_language}/products/#{product_id}.json")
    #   response.body ? response.body['product'] : false
    # end

    def get_script(script_id)
      response = get("#{@shop_language}/shop/scripts/#{script_id}.json")
      response.body ? response.body['script'] : false
    end
    # TODO
    # def delete_script(script_id)
    #   response = delete("#{@shop_language}/shop/scripts/#{script_id}.json")
    #   response.body ? response.body['product'] : false
    # end
  end
end
