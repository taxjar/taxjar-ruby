require 'taxjar/base'

module Taxjar
  class SummaryRate < Taxjar::Base
    extend ModelAttribute
    
    attribute :country_code, :string
    attribute :country,       :string
    attribute :region_code,  :string
    attribute :region,       :string
    
    class MinimumRate < SummaryRate
      extend ModelAttribute
      
      attribute :label, :string
      attribute :rate,  :float
    end
    
    class AverageRate < SummaryRate
      extend ModelAttribute

      attribute :label, :string
      attribute :rate,  :float
    end
    
    object_attr_reader MinimumRate, :minimum_rate
    object_attr_reader AverageRate, :average_rate
  end
end
