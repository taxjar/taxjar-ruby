require 'taxjar/api/utils'
module Taxjar
  module API
    include Taxjar::API::Utils

    def categories(options = {})
      perform_get_with_objects("/v2/categories", 'categories', options, Taxjar::Category)
    end

    def rates_for_location(postal_code, options ={})
      perform_get_with_object("/v2/rates/#{postal_code}", 'rate', options, Taxjar::Rate)
    end



  end
end
