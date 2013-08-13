module Seoshop
  module Account
    def get_rate_limit
      response = get("#{@shop_language}/account/ratelimit.json")
      response.body ? response.body['accountRatelimit'] : false
    end
  end
end

