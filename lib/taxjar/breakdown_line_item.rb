require 'taxjar/base'

module Taxjar
  class BreakdownLineItem < Taxjar::Base
    attr_reader :id, :state_taxable_amount, :state_sales_tax_rate, :county_taxable_amount,
    :county_tax_rate, :city_taxable_amount, :city_tax_rate, :special_district_taxable_amount
    :special_tax_rate

  end
end
