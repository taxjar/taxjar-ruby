require 'taxjar/base'
require 'taxjar/configuration'
require 'taxjar/breakdown'
require 'taxjar/breakdown_line_item'
require 'taxjar/category'
require 'taxjar/client'
require 'taxjar/line_item'
require 'taxjar/nexus_region'
require 'taxjar/order'
require 'taxjar/rate'
require 'taxjar/refund'
require 'taxjar/shipping'
require 'taxjar/summary_rate'
require 'taxjar/tax'
require 'taxjar/validation'
require 'taxjar/version'

module Taxjar
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
