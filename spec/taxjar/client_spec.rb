require 'helper'

describe Taxjar::Client do
  describe '#user_agent' do
    it 'returns string with version' do
      client = Taxjar::Client.new
      expect(client.user_agent).to eq("TaxjarRubyGem/#{Taxjar::Version}")
    end
  end
end
