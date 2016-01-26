module Seoshop
  class Client::OrderedProduct
    def initialize(client, checkout_id, details)
      @client = client
      @checkout_id = checkout_id
      @details = details
    end

    def create
      response = @client.post("#{@language}/checkouts/#{@checkout_id}/products.json", @details)
      fail "Checkout with id: #{@checkout_id} could not add product with variant id #{@shop_code}." unless response.status == 201
    end
  end
end
