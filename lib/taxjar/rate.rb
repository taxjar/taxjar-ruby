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
    attribute :freight_taxable,         :boolean

    # International
    attribute :country,                 :string
    attribute :name,                    :string

    # Australia / SST States
    attribute :country_rate,            :float
    
    # European Union
    attribute :standard_rate,           :float
    attribute :reduced_rate,            :float
    attribute :super_reduced_rate,      :float
    attribute :parking_rate,            :float
    attribute :distance_sale_threshold, :float
  end
end
