require 'taxjar/base'

module Taxjar
  class Address < Taxjar::Base
    extend ModelAttribute

    attribute :country, :string
    attribute :state,   :string
    attribute :zip,     :string
    attribute :city,    :string
    attribute :street,  :string
  end
end
