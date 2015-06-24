require 'taxjar/api/utils'
module Taxjar
  module API
    module Standard
      include Taxjar::API::Utils

      def rate_by_postal_code(postal_code)
        perform_get_with_object("/v2/standard/rates/#{postal_code}", 'rate', Taxjar::Rate)
      end
    end
  end
end


