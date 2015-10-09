require 'taxjar/base'

module Taxjar
  class Shipping < Taxjar::Base
    attr_reader :taxable_amount, :tax_collectable, :state_amount, :state_sales_tax_rate,
                :county_amount, :county_tax_rate, :city_amount, :city_tax_rate, :special_district_amount,
                :special_tax_rate

  end
end
