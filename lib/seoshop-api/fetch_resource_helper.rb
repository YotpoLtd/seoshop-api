module Seoshop
  module FetchResourceHelper
    DEFAULT_API_LIMIT = 50
    MAX_API_LIMIT = 250
    # Allows to fetch collection with pagination ability.
    # Params `options` supports key `:as` to allow user is specify entity name
    # for given resource. By default its equal to `name` parameter.
    #
    # NOTES: Default per page limit is expected to be 50 http://developers.seoshop.com/api/getting-started/resources
    #
    def fetch_collection(name, options = {})
      collection = []
      fetch_in_batches(name, options) do |batch|
        collection += batch
      end
      collection
    end

    # Allows to fetch collections with block to prevent memory allocations for big collections
    def fetch_in_batches(name, options = {})
      total = get("#{shop_language}/#{name}/count.json").body['count']
      limit = options[:limit] || DEFAULT_API_LIMIT
      raise "Max api limit is 250 items" if limit > MAX_API_LIMIT
      return if total == 0
      max_page = (total/limit).round + 1
      1.upto(max_page) do |page|
        result = get("#{shop_language}/#{name}.json?page=#{page}&limit=#{limit}").body[options[:as] || name]
        next if result.empty?
        yield result
      end
    end
  end
end
