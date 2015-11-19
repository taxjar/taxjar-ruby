require 'taxjar/api/utils'

module Taxjar
  module API
    module Order
      include Taxjar::API::Utils

      def list_orders(options = {})
        perform_get_with_array("/v2/transactions/orders", 'orders', options)
      end

      def show_order(id, options = {})
        perform_get_with_object("/v2/transactions/orders/#{id}", 'order', options, Taxjar::Order)
      end

      def create_order(options = {})
        perform_post_with_object("/v2/transactions/orders", 'order', options, Taxjar::Order)
      end

      def update_order(options = {})
        id = options.fetch(:transaction_id)
        perform_put_with_object("/v2/transactions/orders/#{id}", 'order', options, Taxjar::Order)
      end

      def delete_order(id, options={})
        perform_delete_with_object("/v2/transactions/orders/#{id}", 'order', options, Taxjar::Order)
      end
    end
  end
end
