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

    def tax_for_order(options = {})
      perform_post_with_object("/v2/taxes", 'tax', options, Taxjar::Tax)
    end

    def create_order(options = {})
      perform_post_with_object("/v2/transactions/orders", 'order', options, Taxjar::Order)
    end

    def update_order(options = {})
      id = options.fetch(:transaction_id)
      perform_put_with_object("/v2/transactions/orders/#{id}", 'order', options, Taxjar::Order)
    end

    def create_refund(options = {})
      perform_post_with_object("/v2/transactions/refunds", 'refund', options, Taxjar::Refund)
    end

    def update_refund(options = {})
      id = options.fetch(:transaction_id)
      perform_put_with_object("/v2/transactions/refunds/#{id}", 'refund', options, Taxjar::Refund)
    end

  end
end
