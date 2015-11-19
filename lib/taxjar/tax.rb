require 'taxjar/base'

module Taxjar
  class Tax < Taxjar::Base
    extend ModelAttribute
    
    attribute :order_total_amount, :float
    attribute :shipping,           :float
    attribute :taxable_amount,     :float
    attribute :amount_to_collect,  :float
    attribute :rate,               :float
    attribute :has_nexus,          :boolean
    attribute :freight_taxable,    :boolean
    attribute :tax_source,         :string

    object_attr_reader Taxjar::Breakdown, :breakdown
  end
end
