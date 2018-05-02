require 'taxjar/base'

module Taxjar
  class ExemptRegion < Taxjar::Base
    extend ModelAttribute

    attribute :country, :string
    attribute :state,   :string
  end
end
