require 'taxjar/api/utils'

module Taxjar
  module API
    module Refund
      include Taxjar::API::Utils

      def list_refunds(options = {})
        perform_get_with_array("/v2/transactions/refunds", 'refunds', options)
      end

      def show_refund(id, options = {})
        perform_get_with_object("/v2/transactions/refunds/#{id}", 'refund', options, Taxjar::Refund)
      end

      def create_refund(options = {})
        perform_post_with_object("/v2/transactions/refunds", 'refund', options, Taxjar::Refund)
      end

      def update_refund(options = {})
        id = options.fetch(:transaction_id)
        perform_put_with_object("/v2/transactions/refunds/#{id}", 'refund', options, Taxjar::Refund)
      end

      def delete_refund(id, options={})
        perform_delete_with_object("/v2/transactions/refunds/#{id}", 'refund', options, Taxjar::Refund)
      end
    end
  end
end
