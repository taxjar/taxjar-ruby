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

      def perform_request_with_object(request_method, path, object_key, options)
        response = perform_request(request_method, path, object_key, options)
        klass.new(response)
      end

      def perform_request_with_objects(request_method, path, object_key, options, klass)
        response_array = perform_request(request_method, path, object_key, options) || []
        response_array.collect do |element|
          klass.new(element)
        end
      end
    end
  end
end
