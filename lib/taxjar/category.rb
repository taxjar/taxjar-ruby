require 'taxjar/base'

module Taxjar
  class Category < Taxjar::Base
    extend ModelAttribute
    
    attribute :name,             :string
    attribute :product_tax_code, :string
    attribute :description,      :string
  end
end
