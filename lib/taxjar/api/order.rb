require 'taxjar/api/utils'
module Taxjar
  module API
    module Order
      include Taxjar::API::Utils

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

      def list_orders
      end

      def show_order
      end

      def delete_order
      end
    end
  end
end
