module Taxjar
  class Configuration
    attr_accessor :api_key, :base_url

    def base_url
      @base_url ||= 'https://api.taxjar.com'
    end
  end
end
