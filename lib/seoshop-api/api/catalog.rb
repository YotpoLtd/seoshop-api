#
# http://developers.seoshop.com/api/resources/catalog
#
module Seoshop
  module Catalog
    def get_catalog(catalog_id = nil)
      response = catalog_id.nil? ? get("#{@shop_language}/catalog.json") : get("#{@shop_language}/catalog/#{catalog_id}.json")
      response.body ? response.body['products'] : false
    end

    def get_catalog_count
      response = get("#{@shop_language}/catalog/count.json")
      response.body ? response.body['products'] : false
    end
  end
end
