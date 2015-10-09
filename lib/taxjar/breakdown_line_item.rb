require 'taxjar/base'

module Taxjar
  class BreakdownLineItem < Taxjar::Base
    attr_reader :id, :tax_collectable, :state_taxable_amount, :state_sales_tax_rate, :state_amount, 
    :county_taxable_amount, :county_tax_rate, :county_amount, :city_taxable_amount, :city_tax_rate, :city_amount, 
    :special_district_taxable_amount, :special_tax_rate, :special_district_amount

  end
end
