module Seoshop
  module FetchResourceHelper
    PER_PAGE = 50
    # Allows to fetch collection with pagination ability.
    # Params `options` supports key `:as` to allow user is specify entity name
    # for given resource. By default its equal to `name` parameter.
    #
    # NOTES: Default per page limit is expected to be 50 (not documented API feature).
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
      return if total == 0
      max_page = (total/PER_PAGE).round + 1
      1.upto(max_page) do |page|
        result = get("#{shop_language}/#{name}.json?page=#{page}").body[options[:as] || name]
        next if result.empty?
        yield result
      end
    end
  end
end
