require 'seoshop-api/version'
require 'seoshop-api/client'
require 'seoshop-api/client/order'
require 'seoshop-api/client/ordered_product'

module Seoshop
  class << self

    # @!attribute parallel_requests
    # @return [Integer String] defines the maximum parallel request for the gem to preform
    attr_accessor :parallel_requests

    # Configuration interface of the gem
    #
    # @yield [self] to accept configuration settings
    def configure
      yield self
      true
    end

    #
    # @return an instance of Seoshop::Client
    #
    def client(api_key, api_secret, access_token, shop_language, cluster_id = 'eu1')
      @client ||= Seoshop::Client.new(api_key, api_secret, access_token, shop_language, cluster_id)
    end
  end
end
