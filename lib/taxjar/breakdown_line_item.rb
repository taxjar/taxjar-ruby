require 'taxjar/base'

module Taxjar
  class BreakdownLineItem < Taxjar::Base
    extend ModelAttribute
      
    attribute :id,                              :integer
    attribute :tax_collectable,                 :float
    attribute :state_taxable_amount,            :float
    attribute :state_sales_tax_rate,            :float
    attribute :state_amount,                    :float
    attribute :county_taxable_amount,           :float
    attribute :county_tax_rate,                 :float
    attribute :county_amount,                   :float
    attribute :city_taxable_amount,             :float
    attribute :city_tax_rate,                   :float
    attribute :city_amount,                     :float
    attribute :special_district_taxable_amount, :float
    attribute :special_tax_rate,                :float
    attribute :special_district_amount,         :float
  end
end
