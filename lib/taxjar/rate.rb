require 'taxjar/base'

module Taxjar
  class Rate < Taxjar::Base
    extend ModelAttribute

    attribute :zip,                    :string
    attribute :state,                  :string
    attribute :state_rate,             :float
    attribute :county,                 :string
    attribute :county_rate,            :float
    attribute :city,                   :string
    attribute :city_rate,              :float
    attribute :combined_district_rate, :float
    attribute :combined_rate,          :float
  end
end
