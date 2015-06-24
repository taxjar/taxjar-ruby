require 'taxjar/api/standard'
require 'taxjar/api/enhanced'

module Taxjar
  module API
    include Taxjar::API::Standard
    include Taxjar::API::Enhanced
  end
end
