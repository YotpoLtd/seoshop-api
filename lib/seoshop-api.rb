require 'seoshop-api/version'
require 'seoshop-api/client'

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
    # Makes sure that the method missing is checked with the Seoshop::Client instance
    #
    # @param method_name [String] the name of the method we want to run
    # @param include_private [Boolean] defines wether to check for private functions as well
    def respond_to_missing?(method_name, include_private=false)
      client.respond_to?(method_name, include_private)
    end

    #
    # @return an instance of Seoshop::Client
    #
    def client(api_key, api_secret, access_token, shop_language, cluster_id = 'eu1')
      @client ||= Seoshop::Client.new(api_key, api_secret, access_token, shop_language, cluster_id)
    end

    private

    #
    # executes any function on the Seoshop::Client instance
    #
    # @param args [*] any argument that we want to pass to the client function
    # @param block [Block] any block that is passed to the client function
    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end
