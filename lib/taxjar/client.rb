require 'taxjar/api/api'
require 'taxjar/error'
require 'taxjar/api/request'
require 'taxjar/api/utils'
module Taxjar
  class Client
    include Taxjar::API
    attr_accessor :api_key

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [Taxjar::Client]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    # @return [Boolean]
    def api_key?
      !!@api_key
    end

    # @return [String]
    def user_agent
      "TaxjarRubyGem/#{Taxjar::Version}"
    end
  end
end
