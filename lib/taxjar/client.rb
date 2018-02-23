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

    def user_agent
      "TaxjarRubyGem/#{Taxjar::Version}"
    end
  end
end
