module Seoshop
  module Tax

    def get_taxes
      response = get("#{@shop_language}/taxes.json")
      response.body ? response.body : false
    end

    def get_default_tax
      taxes = get_taxes[:taxes]
      list = taxes.map { |x| x if x.delete(:isDefault) }
      list.keep_if { |element| !element.nil? }[0]
    end

  end
end
