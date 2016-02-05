module Seoshop
  class Client::OrderedProduct
    def initialize(client, checkout_id, details)
      @client = client
      @checkout_id = checkout_id
      @details = details
    end

    def create!
      response = @client.post("#{@client.shop_language}/checkouts/#{@checkout_id}/products.json", @details)
      fail "Checkout with id: #{@checkout_id} could not add product with data: #{@details}." unless response.status == 201
    end
  end
end
