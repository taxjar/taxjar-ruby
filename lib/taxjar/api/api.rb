require 'taxjar/api/utils'

module Taxjar
  module API
    include Taxjar::API::Utils

    def categories(options = {})
      perform_get_with_objects("/v2/categories", 'categories', options, Taxjar::Category)
    end

    def rates_for_location(postal_code, options = {})
      perform_get_with_object("/v2/rates/#{postal_code}", 'rate', options, Taxjar::Rate)
    end

    def tax_for_order(options = {})
      perform_post_with_object("/v2/taxes", 'tax', options, Taxjar::Tax)
    end
    
    def nexus_regions(options = {})
      perform_get_with_objects("/v2/nexus/regions", 'regions', options, Taxjar::NexusRegion)
    end
    
    def validate(options = {})
      perform_get_with_object("/v2/validation", 'validation', options, Taxjar::Validation)
    end
    
    def summary_rates(options = {})
      perform_get_with_objects("/v2/summary_rates", 'summary_rates', options, Taxjar::SummaryRate)
    end
  end
end
