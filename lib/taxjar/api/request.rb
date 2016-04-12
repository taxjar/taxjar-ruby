require 'addressable/uri'
require 'http'

module Taxjar
  module API
    class Request
      BASE_URL = 'https://api.taxjar.com'

      attr_reader :client, :uri, :headers, :request_method, :path, :object_key, :options

      # @param client [Taxjar::Client]
      # @param request_method [String, Symbol]
      # @param path [String]
      # @param object_key [String]
      def initialize(client, request_method, path, object_key, options = {})
        @client = client
        @request_method = request_method
        @path = path
        @uri = Addressable::URI.parse(BASE_URL + path)
        set_request_headers
        @object_key = object_key
        @options = options
        set_http_timeout
      end

      def perform
        options_key = @request_method == :get ? :params : :json
        response = HTTP.timeout(@http_timeout).with(headers).public_send(request_method, uri.to_s, options_key =>  @options)
        response_body = symbolize_keys!(response.parse)
        fail_or_return_response_body(response.code, response_body)
      end

      private

        def set_request_headers
          @headers = {}
          @headers[:user_agent] = client.user_agent
          @headers[:authorization] = "Bearer #{client.api_key}"
        end

        def set_http_timeout
          @http_timeout = {}
          @http_timeout[:write] = @options[:timeout]
          @http_timeout[:connect] = @options[:timeout]
          @http_timeout[:read] = @options[:timeout]
        end

        def symbolize_keys!(object)
          if object.is_a?(Array)
            object.each_with_index do |val, index|
              object[index] = symbolize_keys!(val)
            end
          elsif object.is_a?(Hash)
            object.keys.each do |key|
              object[key.to_sym] = symbolize_keys!(object.delete(key))
            end
          end
          object
        end

        def fail_or_return_response_body(code, body)
          e = extract_error(code, body)
          fail(e) if e
          body[object_key.to_sym]
        end

        def extract_error(code, body)
          klass = Taxjar::Error::ERRORS[code]
          if !klass.nil?
            klass.from_response(body)
          end
        end
    end
  end
end
