require 'taxjar/base'

module Taxjar
  class Customer < Taxjar::Base
    extend ModelAttribute

    attribute :customer_id,    :string
    attribute :exemption_type, :string
    attribute :name,           :string
    attribute :country,        :string
    attribute :state,          :string
    attribute :zip,            :string
    attribute :city,           :string
    attribute :street,         :string

    def exempt_regions
      map_collection(Taxjar::ExemptRegion, :exempt_regions)
    end
  end
end
