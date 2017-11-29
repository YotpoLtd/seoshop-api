module Seoshop
  module ShopScript

    def get_scripts_count(params = {})
      response = get("#{@shop_language}/shop/scripts/count.json", params)
      response.body ? response.body['count'].to_i : 0
    end
    def get_scripts(params = {})
      response = get("#{@shop_language}/shop/scripts.json", params)
      response.body ? response.body['shopScript'] || [] : []
    end

    def post_script(params)
      response = post("#{@shop_language}/shop/scripts.json", { "shopScript" => params })
      response.body ? response.body['shopScript'] : false
    end

    def update_script(script_id, params)
      response = put("#{@shop_language}/shop/scripts/#{script_id}.json", { "shopScript" => params } )
      response.body ? response.body['shopScript'] : {}
    end

    def get_script(script_id)
      response = get("#{@shop_language}/shop/scripts/#{script_id}.json")
      response.body ? response.body['shopScript'] : nil
    end
    def delete_script(script_id)
      response = delete("#{@shop_language}/shop/scripts/#{script_id}.json")
      true
    end
  end
end
