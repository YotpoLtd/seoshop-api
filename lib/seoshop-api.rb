require 'seoshop-api/version'
require 'seoshop-api/client'

module Seoshop
  class << self
    # @!attribute url
    # @return [String] the base url of the Seoshop Api
    attr_accessor :url

    # @!attribute parallel_requests
    # @return [Integer String] defines the maximum parallel request for the gem to preform
    attr_accessor :parallel_requests

    # @!attribute app_key
    # @return [String] the app key that is registered with Storenvy
    attr_accessor :app_key

    # @!attribute secret
    # @return [String] the secret that is registered with Storenvy
    attr_accessor :secret

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
    def client(access_token, shop_language)
      @client ||= Seoshop::Client.new(access_token, shop_language)
    end
  end
end
