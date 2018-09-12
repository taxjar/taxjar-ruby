require 'taxjar/base'

module Taxjar
  class Jurisdictions < Taxjar::Base
    extend ModelAttribute

    attribute :country, :string
    attribute :state,   :string
    attribute :county,  :string
    attribute :city,    :string
  end
end
