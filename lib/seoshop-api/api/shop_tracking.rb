module Seoshop
  module ShopTracking

    def get_trackings_count(params = {})
      response = get("#{@shop_language}/shop/tracking/count.json", params)
      response.body ? response.body['count'] : false
    end
    def get_trackings(params = {})
      response = get("#{@shop_language}/shop/trackings.json", params)
      puts response.body
      response.body ? response.body['shopTracking'] : false
    end

    def post_tracking(params)
      response = post("#{@shop_language}/shop/trackings.json", { "shopTracking" => params })
      puts response
      response.body ? response.body['shopTracking'] : false
    end

    def update_tracking(tracking_id, params)
      response = put("#{@shop_language}/shop/trackings/#{tracking_id}.json", { "shopTracking" => params } )
      response.body ? response.body['shopTracking'] : false
    end

    def get_tracking(tracking_id)
      response = get("#{@shop_language}/shop/trackings/#{tracking_id}.json")
      response.body ? response.body['shopTracking'] : false
    end
    def delete_tracking(tracking_id)
      response = delete("#{@shop_language}/shop/trackings/#{script_id}.json")
      true
    end
  end
end
