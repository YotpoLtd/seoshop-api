module Seoshop
  module Account
    def get_rate_limit
      get("#{@shop_language}/account/ratelimit.json")['accountRatelimit']
    end
  end
end

