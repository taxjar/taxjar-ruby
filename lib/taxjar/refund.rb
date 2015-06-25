require 'taxjar/base'

module Taxjar
  class Refund < Taxjar::Base
    attr_reader :transaction_id

  end
end
