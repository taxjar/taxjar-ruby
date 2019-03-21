require 'taxjar/api/api'
require 'taxjar/api/customer'
require 'taxjar/api/order'
require 'taxjar/api/refund'
require 'taxjar/error'
require 'taxjar/api/request'
require 'taxjar/api/utils'

module Taxjar
  class Client
    include Taxjar::API
    include Taxjar::API::Customer
    include Taxjar::API::Order
    include Taxjar::API::Refund

    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :headers
    attr_accessor :http_proxy

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def api_key?
      !!@api_key
    end

    def set_api_config(key, value)
      instance_variable_set("@#{key}", value)
    end

    def get_api_config(key)
      instance_variable_get("@#{key}")
    end

    def user_agent
      "TaxjarRubyGem/#{Taxjar::Version}"
    end
  end
end
