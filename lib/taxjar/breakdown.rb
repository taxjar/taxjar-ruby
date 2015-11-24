require 'taxjar/base'
require 'taxjar/shipping'

module Taxjar
  class Breakdown < Taxjar::Base
    extend ModelAttribute
    
    attribute :state_taxable_amount,             :float
    attribute :state_tax_collectable,            :float
    attribute :county_taxable_amount,            :float
    attribute :county_tax_collectable,           :float
    attribute :city_taxable_amount,              :float
    attribute :city_tax_collectable,             :float
    attribute :special_district_taxable_amount,  :float
    attribute :special_district_tax_collectable, :float
    
    # Canada
    attribute :pst,                              :float
    attribute :pst_rate,                         :float
    attribute :pst_taxable_amount,               :float
    attribute :gst,                              :float
    attribute :gst_rate,                         :float
    attribute :gst_taxable_amount,               :float
    attribute :qst,                              :float
    attribute :qst_rate,                         :float
    attribute :qst_taxable_amount,               :float

    object_attr_reader Taxjar::Shipping, :shipping

    def line_items
      map_collection(Taxjar::BreakdownLineItem, :line_items)
    end
  end
end
