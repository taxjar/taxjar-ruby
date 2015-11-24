require 'taxjar/base'

module Taxjar
  class Rate < Taxjar::Base
    extend ModelAttribute

    attribute :zip,                     :string
    attribute :state,                   :string
    attribute :state_rate,              :float
    attribute :county,                  :string
    attribute :county_rate,             :float
    attribute :city,                    :string
    attribute :city_rate,               :float
    attribute :combined_district_rate,  :float
    attribute :combined_rate,           :float
    
    # International
    attribute :country,                 :string
    
    # Canada
    attribute :hst_rate,                :float
    attribute :pst_rate,                :float
    attribute :gst_rate,                :float
    attribute :qst_rate,                :float
    
    # European Union
    attribute :standard_rate,           :float
    attribute :reduced_rate,            :float
    attribute :super_reduced_rate,      :float
    attribute :parking_rate,            :float
    attribute :distance_sale_threshold, :float
    attribute :freight_taxable,         :boolean
  end
end
