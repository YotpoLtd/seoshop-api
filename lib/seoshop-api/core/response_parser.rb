require 'typhoeus/adapters/faraday'
require 'faraday_middleware/response_middleware'

module Seoshop
  class ResponseParser < Faraday::Response::Middleware
    def call(env)
      # "env" contains the request
      @app.call(env).on_complete do
        body = false
        if env[:status] == 200
          body = env[:response].body.response || env[:response].body
        elsif env[:status] == 401
          raise HTTPUnauthorized.new 'invalid Seoshop credentials'
        elsif env[:status] == 403
          raise HTTPForbidden.new env[:response].body.message
        elsif env[:status] == 404
          raise HTTPNotFound.new env[:response].body.message
        elsif env[:status] == 429
          rate_limits = env[:response_headers]['X-RateLimit-Remaining'].split('/')
          rate_limits_reset = env[:response_headers]['X-RateLimit-Reset'].split('/')
          seconds = rate_limits_reset[0] if rate_limits[0] == '-1'
          seconds = rate_limits_reset[1] if rate_limits[1] == '-1'
          seconds = rate_limits_reset[2] if rate_limits[2] == '-1'
          raise RateLimit.new "RateLimit reset in #{seconds} seconds"
        elsif env[:response] && env[:response].body && env[:response].body.status
          body = env[:response].body.status
        end
        env[:body] = body
      end
    end
    class RateLimit < Exception; end
    class HTTPForbidden < Exception; end
    class HTTPUnauthorized < Exception; end
    class HTTPNotFound < Exception; end
  end
end
