require 'taxjar/base'

module Taxjar
  class Shipping < Taxjar::Base
    extend ModelAttribute
    
    attribute :taxable_amount,          :float
    attribute :tax_collectable,         :float
    attribute :state_amount,            :float
    attribute :state_sales_tax_rate,    :float
    attribute :county_amount,           :float
    attribute :county_tax_rate,         :float
    attribute :city_amount,             :float
    attribute :city_tax_rate,           :float
    attribute :special_district_amount, :float
    attribute :special_tax_rate,        :float
    
    # Canada
    attribute :pst,                     :float
    attribute :pst_rate,                :float
    attribute :pst_taxable_amount,      :float
    attribute :gst,                     :float
    attribute :gst_rate,                :float
    attribute :gst_taxable_amount,      :float
    attribute :qst,                     :float
    attribute :qst_rate,                :float
    attribute :qst_taxable_amount,      :float
  end
end
