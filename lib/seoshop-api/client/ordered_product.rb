module Seoshop
  class Client::OrderedProduct
    def initialize(client, checkout_id, details)
      @client = client
      @checkout_id = checkout_id
      @details = details
    end

    def create!
      response = @client.post("#{@client.shop_language}/checkouts/#{@checkout_id}/products.json", @details)
      fail("Could not add product to checkout #{@checkout_id}, request body: #{@details}, response body: #{response.body.to_hash.to_s}") unless response.status == 201
    end
  end
end
