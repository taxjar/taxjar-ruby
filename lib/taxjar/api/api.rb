require 'taxjar/api/utils'
module Taxjar
  module API
    include Taxjar::API::Utils

    def categories(options = {})
      perform_get_with_objects("/v2/enhanced/categories", 'categories', options, Taxjar::Category)
    end

    def rates_for_location(postal_code, options ={})
      perform_get_with_object("/v2/enhanced/rates/#{postal_code}", 'rate', options, Taxjar::Rate)
    end

    def tax_for_order(options = {})
      perform_post_with_object("/v2/enhanced/taxes", 'tax', options, Taxjar::Tax)
    end

    def create_order(options = {})
      perform_post_with_object("/v2/enhanced/transactions/orders", 'order', Taxjar::Order, options)
    end

    def update_order(id, options = {})
      perform_put_with_object("/v2/enhanced/transactions/orders/#{id}", 'order', Taxjar::Order, options)
    end

    def create_refund(options = {})
      perform_post_with_object("/v2/enhanced/transactions/refunds", 'order', Taxjar::Refund, options)
    end

    def update_refund(id, options = {})
      perform_put_with_object("/v2/enhanced/transactions/refunds/#{id}", 'order', Taxjar::Refund, options)
    end

  end
end
