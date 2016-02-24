module Seoshop
  class Client::Order
    class CheckoutError < StandardError
    end

    attr_reader :order_id, :client, :checkout_details, :payment_details, :shipping_details, :checkout_id,
                :checkout_body, :validation_body, :number

    def initialize(client, checkout_details, payment_details, shipping_details)
      @client = client
      @payment_details = payment_details
      @shipping_details = shipping_details
      @checkout_response = @client.post("#{language}/checkouts.json", checkout_details)
      @checkout_body ||= @checkout_response.body
      if @checkout_body
        @checkout_id ||= @checkout_body['id']
      end
    end

    def valid?
      update_shipping_and_paymeny_info
      @validation_body = client.get("#{language}/checkouts/#{checkout_id}/validate.json").body
      @validation_body[:validated]
    end

    def save!
      response = client.post("#{language}/checkouts/#{checkout_id}/order.json", checkout_attrs)
      if response.status == 201 || response.status == 200
        @order_id = response.body['order_id']
      else
        error = response.body[:error]
        fail CheckoutError, "Checkout with id: #{checkout_id} could not convert into an order. Errors: #{error[:message]} (code: #{error[:code]})"
      end
    end

    def update!(attrs)
      response = client.put("#{language}/orders/#{order_id}.json", { order: attrs })
      unless response.status == 200
        fail CheckoutError, "Order with id: #{order_id} could not be updated."
      end
      @number = response.body['number']
    end

    private

    def language
      @client.shop_language
    end

    def update_shipping_and_paymeny_info
      response = client.put("#{language}/checkouts/#{checkout_id}.json", { shipment_method: shipping_details, payment_method: payment_details })
      fail CheckoutError, "Checkout with id: #{checkout_id} could not be updated." unless response.status == 200
    end

    def checkout_attrs
      result = checkout_body.slice(:mode, :customer, :billing_address, :shipping_address, :newsletter, :terms, :notifications)
        .merge(quote_id: checkout_body[:quote][:id])
        .merge(shipment_method: checkout_body.slice(:shipment_method).slice(:id), payment_method: checkout_body.slice(:payment_method).slice(:id))
      sanitize_hash(result)
    end

    def sanitize_hash(h)
      # h.keep_if {|_, v| v.compact.any? }.compact!
      h.keep_if {|k, v| v.is_a?(Hash) ? !v.empty? && sanitize_hash(v) : !v.nil? }
    end
  end
end
