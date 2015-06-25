require 'taxjar/base'

module Taxjar
  class Category < Taxjar::Base
    attr_reader :name, :product_tax_code, :description
  end
end
