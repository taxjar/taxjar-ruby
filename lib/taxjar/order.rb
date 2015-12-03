require 'taxjar/base'

module Taxjar
  class Order < Taxjar::Base
    extend ModelAttribute
    
    attribute :transaction_id,   :string
    attribute :user_id,          :integer
    attribute :transaction_date, :string
    attribute :from_country,     :string
    attribute :from_zip,         :string
    attribute :from_state,       :string
    attribute :from_city,        :string
    attribute :from_street,      :string
    attribute :to_country,       :string
    attribute :to_zip,           :string
    attribute :to_state,         :string
    attribute :to_city,          :string
    attribute :to_street,        :string
    attribute :amount,           :float
    attribute :shipping,         :float
    attribute :sales_tax,        :float

    def line_items
      map_collection(Taxjar::LineItem, :line_items)
    end
  end
end
