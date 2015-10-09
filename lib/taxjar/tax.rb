require 'taxjar/base'

module Taxjar
  class Tax < Taxjar::Base
    attr_reader :order_total_amount, :shipping, :taxable_amount, :amount_to_collect, :rate, 
                :has_nexus, :freight_taxable, :tax_source

    object_attr_reader Taxjar::Breakdown, :breakdown

  end
end
