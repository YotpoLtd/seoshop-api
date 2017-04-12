module Seoshop
  module Account
    def get_account
      response = get("#{@shop_language}/account.json")
      response.body ? response.body['account'] : false
    end

    def get_rate_limit
      response = get("#{@shop_language}/account/ratelimit.json")
      response.body ? response.body['accountRatelimit'] : false
    end
  end
end

