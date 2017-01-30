require 'taxjar/base'

module Taxjar
  class LineItem < Taxjar::Base
    extend ModelAttribute
    
    attribute :id,                 :string
    attribute :quantity,           :integer
    attribute :product_identifier, :string
    attribute :description,        :string
    attribute :unit_price,         :float
    attribute :discount,           :float
    attribute :sales_tax,          :float
  end
end
