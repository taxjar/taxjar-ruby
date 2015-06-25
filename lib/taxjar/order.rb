require 'taxjar/base'

module Taxjar
  class Order < Taxjar::Base
    attr_reader :transaction_id

  end
end
