require 'taxjar/api/request'

module Taxjar
  module API
    module Utils
      def perform_request(request_method, path, object_key, options = {})
        Taxjar::API::Request.new(self, request_method, path, object_key, options).perform
      end

      def perform_get_with_object(path, object_key, options, klass)
        perform_request_with_object(:get, path, object_key, options, klass)
      end

      def perform_get_with_objects(path, object_key, options, klass)
        perform_request_with_objects(:get, path, object_key, options, klass)
      end

      def perform_get_with_array(path, object_key, options)
        perform_request_with_array(:get, path, object_key, options)
      end

      def perform_post_with_object(path, object_key, options, klass)
        perform_request_with_object(:post, path, object_key, options, klass)
      end

      def perform_put_with_object(path, object_key, options, klass)
        perform_request_with_object(:put, path, object_key, options, klass)
      end

      def perform_delete_with_object(path, object_key, options, klass)
        perform_request_with_object(:delete, path, object_key, options, klass)
      end

      def perform_request_with_object(request_method, path, object_key, options, klass)
        response = perform_request(request_method, path, object_key, options)
        klass.new(response)
      end

      def perform_request_with_objects(request_method, path, object_key, options, klass)
        response_array = perform_request(request_method, path, object_key, options) || []
        response_array.collect do |element|
          klass.new(element)
        end
      end

      def perform_request_with_array(request_method, path, object_key, options)
        perform_request(request_method, path, object_key, options) || []
      end
    end
  end
end
