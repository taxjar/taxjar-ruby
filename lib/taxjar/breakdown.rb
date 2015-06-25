require 'taxjar/base'
require 'taxjar/shipping'

module Taxjar
  class Breakdown < Taxjar::Base
    attr_reader :state_taxable_amount, :state_tax_collectable, :county_taxable_amount,
      :county_tax_collectable, :city_tax_collectable, 
      :special_district_taxable_amount, :special_district_tax_collectable

    object_attr_reader Taxjar::Shipping, :shipping

    def line_items
      @line_items ||= map_collection(Taxjar::BreakdownLineItem, :line_items)
    end
  end
end
