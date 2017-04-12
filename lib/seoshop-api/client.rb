require 'active_support/notifications'
require 'faraday'
require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'faraday_middleware'
require 'seoshop-api/core/response_parser'
require 'seoshop-api/version'
require 'seoshop-api/api/order'
require 'seoshop-api/api/shop'
require 'seoshop-api/api/product'
require 'seoshop-api/api/product_category'
require 'seoshop-api/api/brand'
require 'seoshop-api/api/tax'
require 'seoshop-api/api/customer'
require 'seoshop-api/api/account'
require 'seoshop-api/api/shop_script'
require 'seoshop-api/api/shop_tracking'
require 'seoshop-api/api/catalog'
require 'seoshop-api/fetch_resource_helper'

module Seoshop
  class Client
    include Seoshop::Order
    include Seoshop::Shop
    include Seoshop::ShopScript
    include Seoshop::ShopTracking
    include Seoshop::Product
    include Seoshop::ProductCategory
    include Seoshop::Customer
    include Seoshop::Account
    include Seoshop::Brand
    include Seoshop::Tax
    include Seoshop::Catalog
    include Seoshop::FetchResourceHelper

    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :access_token
    attr_accessor :shop_language

    SERVER_EU1_LIVE  = 'https://api.webshopapp.com/'
    SERVER_US1_LIVE  = 'https://api.shoplightspeed.com/'

    #
    # Creates a new instance of Seoshop::Client
    #
    # @param api_key [String] The App api key
    # @param api_secret [String] The App secret
    # @param access_token [String] The shop access token
    # @param shop_language [String] The shop language
    # @param cluster_id [String] The shop cluster id
    # @param parallel_requests [Integer String] The maximum parallel request to do (5)
    def initialize(api_key, api_secret, access_token, shop_language, cluster_id = 'eu1', parallel_requests = 5)
      @api_key = api_key
      @api_secret = api_secret
      @access_token = access_token
      @shop_language = shop_language
      @url = get_url(cluster_id)
      @parallel_requests = parallel_requests
    end

    def get_url(cluster_id)
      case cluster_id
        when 'eu1'
          SERVER_EU1_LIVE
        when 'us1'
          SERVER_US1_LIVE
        else
          SERVER_EU1_LIVE
      end
    end

    #
    # Does a GET request to the url with the params
    #
    # @param url [String] the relative path in the Seoshop API
    # @param params [Hash] the url params that should be passed in the request
    def get(url, params = {})
      params = params.inject({}){|memo,(k,v)| memo[k.to_s] = v; memo}
      preform(url, :get, params: params) do
        return connection.get(url, params)
      end
    end

    #
    # Does a POST request to the url with the params
    #
    # @param url [String] the relative path in the Seoshop API
    # @param params [Hash] the body of the request
    def post(url, params)
      params = convert_hash_keys(params)
      preform(url, :post, params: params) do
        return connection.post(url, params)
      end
    end

    #
    # Does a PUT request to the url with the params
    #
    # @param url [String] the relative path in the Seoshop API
    # @param params [Hash] the body of the request
    def put(url, params)
      params = convert_hash_keys(params)
      preform(url, :put, params: params) do
        return connection.put(url, params)
      end
    end

    #
    # Does a DELETE request to the url with the params
    #
    # @param url [String] the relative path in the Seoshop API
    def delete(url)
      preform(url, :delete) do
        return connection.delete(url)
      end
    end

    #
    # Does a parallel request to the api for all of the requests in the block
    #
    # @example block
    #   Seoshop.in_parallel do
    #     Seoshop.create_review(review_params)
    #     Seoshop.update_account(account_params)
    #   end
    def in_parallel
      connection.in_parallel do
        yield
      end
    end

    def create_order_client(checkout_details, payment_details, shipping_details)
      Seoshop::Client::Order.new(self, checkout_details, payment_details, shipping_details)
    end

    def create_ordered_product_client(checkout_id, variant_id, quantity, price)
      Seoshop::Client::OrderedProduct.new(self, checkout_id, { variant_id: variant_id , quantity: quantity, special_price_incl: price })
    end

    private

    #
    # Preforms an HTTP request and notifies the ActiveSupport::Notifications
    #
    # @private
    # @param url [String] the url to which preform the request
    # @param type [String]
    def preform(url, type, params = {}, &block)
      ActiveSupport::Notifications.instrument 'Seoshop', request: type, url: url, params: params do
        if connection.in_parallel?
          block.call
        else
          block.call.body
        end
      end
    end

    #
    # @return an instance of Faraday initialized with all that this gem needs
    def connection
      @connection ||= Faraday.new(url: @url, parallel_manager: Typhoeus::Hydra.new(max_concurrency: @parallel_requests), headers: {:seoshop_api_connector => 'Ruby'+ Seoshop::VERSION}) do |conn|

        conn.basic_auth(@api_key, Digest::MD5.hexdigest(@access_token + @api_secret))

        conn.use Seoshop::ResponseParser

        # Set the response to be rashified
        conn.response :rashify

        # Setting request and response to use JSON/XML
        conn.request :multi_json
        conn.response :multi_json

        # Set to use instrumentals to get time logs
        conn.use :instrumentation

        conn.adapter :typhoeus
      end
    end

    def convert_hash_keys(value)
      case value
        when Array
          value.map { |v| convert_hash_keys(v) }
        when Hash
          Hash[value.map { |k, v| [k.to_s, convert_hash_keys(v)] }]
        else
          value
      end
    end
  end
end
