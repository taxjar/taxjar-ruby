require 'taxjar/base'

module Taxjar
  class Refund < Taxjar::Base

    attr_reader :transaction_id, :user_id, :transaction_date, :transaction_reference_id, :to_country, :to_zip,
      :to_state, :to_city, :to_street, :amount, :shipping, :sales_tax

    def line_items
      @line_items ||= map_collection(Woocom::LineItem, :line_items)
    end
  end
end
