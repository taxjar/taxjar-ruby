require 'taxjar/base'
require 'taxjar/shipping'

module Taxjar
  class Breakdown < Taxjar::Base
    extend ModelAttribute
    
    attribute :taxable_amount,                   :float
    attribute :tax_collectable,                  :float
    attribute :combined_tax_rate,                :float
    attribute :state_taxable_amount,             :float
    attribute :state_tax_rate,                   :float
    attribute :state_tax_collectable,            :float
    attribute :county_taxable_amount,            :float
    attribute :county_tax_rate,                  :float
    attribute :county_tax_collectable,           :float
    attribute :city_taxable_amount,              :float
    attribute :city_tax_rate,                    :float
    attribute :city_tax_collectable,             :float
    attribute :special_district_taxable_amount,  :float
    attribute :special_tax_rate,                 :float
    attribute :special_district_tax_collectable, :float

    # International
    attribute :country_taxable_amount,  :float
    attribute :country_tax_rate,        :float
    attribute :country_tax_collectable, :float

    # Canada
    attribute :gst_taxable_amount, :float
    attribute :gst_tax_rate,       :float
    attribute :gst,                :float
    attribute :pst_taxable_amount, :float
    attribute :pst_tax_rate,       :float
    attribute :pst,                :float
    attribute :qst_taxable_amount, :float
    attribute :qst_tax_rate,       :float
    attribute :qst,                :float

    object_attr_reader Taxjar::Shipping, :shipping

    def line_items
      map_collection(Taxjar::BreakdownLineItem, :line_items)
    end
  end
end
