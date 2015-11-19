require 'taxjar/base'

module Taxjar
  class LineItem < Taxjar::Base
    attr_reader :quantity, :product_identifier, :description, :unit_price, :discount, :sales_tax
  end
end
