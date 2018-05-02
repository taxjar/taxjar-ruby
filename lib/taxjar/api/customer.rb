require 'taxjar/api/utils'

module Taxjar
  module API
    module Customer
      include Taxjar::API::Utils

      def list_customers(options = {})
        perform_get_with_array("/v2/customers", 'customers', options)
      end

      def show_customer(id, options = {})
        perform_get_with_object("/v2/customers/#{id}", 'customer', options, Taxjar::Customer)
      end

      def create_customer(options = {})
        perform_post_with_object("/v2/customers", 'customer', options, Taxjar::Customer)
      end

      def update_customer(options = {})
        id = options.fetch(:customer_id)
        perform_put_with_object("/v2/customers/#{id}", 'customer', options, Taxjar::Customer)
      end

      def delete_customer(id, options={})
        perform_delete_with_object("/v2/customers/#{id}", 'customer', options, Taxjar::Customer)
      end
    end
  end
end
