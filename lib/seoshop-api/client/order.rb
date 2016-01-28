module Seoshop
  class Client::Order
    class CheckoutError < StandardError
    end

    attr_reader :id, :client, :checkout_details, :payment_details, :shipping_details, :checkout_id, :checkout_body

    def initialize(client, checkout_details, payment_details, shipping_details)
      @client = client
      @payment_details = payment_details
      @shipping_details = shipping_details
      @checkout_response = @client.post("#{language}/checkouts.json", checkout_details)
      @checkout_id ||= @checkout_response[:id]
      @checkout_body ||= @checkout_response.body
    end

    def valid?
      update_shipping_and_paymeny_info
      client.get("#{language}/checkouts/#{checkout_id}/validate.json").body[:validated]
    end

    def save!
      response = client.post("#{language}/checkouts/#{checkout_id}/order.json", checkout_attrs)
      if response.status == 201 || response.status == 200
        @id = response.body[:order_id]
      else
        error = response.body[:error]
        fail CheckoutError, "Checkout with id: #{checkout_id} could not convert into an order. Errors: #{error[:message]} (code: #{error[:code]})"
      end
    end

    def update(attrs)
      response = client.put("#{language}/orders/#{id}.json", { order: attrs })
      unless response.status == 200
        fail CheckoutError, "Order with id: #{id} could not be updated."
      end
    end

    private

    def language
      @client.shop_language
    end

    def update_shipping_and_paymeny_info
      response = client.put("#{language}/checkouts/#{checkout_id}.json", { shipping_method: shipping_details, payment_method: payment_details })
      fail CheckoutError, "Checkout with id: #{checkout_id} could not be updated." unless response.status == 200
    end

    def checkout_attrs
       sanitize_hash checkout_body.slice(:mode, :customer, :billing_address, :shipping_address, :newsletter, :terms, :notifications)
       .merge(quote_id: checkout_body[:quote][:id])
       .merge(shipment_method: checkout_body.slice(:shipment_method).slice(:id), payment_method: checkout_body.slice(:payment_method).slice(:id))
    end

    def sanitize_hash(h)
      h.keep_if {|_, v| v.compact.any? }.compact!
    end
  end
end
