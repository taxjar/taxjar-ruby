require 'taxjar/base'

module Taxjar
  class LineItem < Taxjar::Base
    extend ModelAttribute
    
    attribute :id,                 :integer
    attribute :quantity,           :integer
    attribute :product_identifier, :string
    attribute :description,        :string
    attribute :unit_price,         :float
    attribute :discount,           :float
    attribute :sales_tax,          :float
    
    # Canada
    attribute :pst,                :float
    attribute :pst_rate,           :float
    attribute :pst_taxable_amount, :float
    attribute :gst,                :float
    attribute :gst_rate,           :float
    attribute :gst_taxable_amount, :float
    attribute :qst,                :float
    attribute :qst_rate,           :float
    attribute :qst_taxable_amount, :float
  end
end
