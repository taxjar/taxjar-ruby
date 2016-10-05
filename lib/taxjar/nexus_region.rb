require 'taxjar/base'

module Taxjar
  class NexusRegion < Taxjar::Base
    extend ModelAttribute
    
    attribute :country_code, :string
    attribute :country,      :string
    attribute :region_code,  :string
    attribute :region,       :string
  end
end
