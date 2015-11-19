require 'taxjar/api/api'
require 'taxjar/api/order'
require 'taxjar/api/refund'
require 'taxjar/error'
require 'taxjar/api/request'
require 'taxjar/api/utils'

module Taxjar
  class Client
    include Taxjar::API
    include Taxjar::API::Order
    include Taxjar::API::Refund

    attr_accessor :api_key

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def api_key?
      !!@api_key
    end

    def user_agent
      "TaxjarRubyGem/#{Taxjar::Version}"
    end
  end
end
