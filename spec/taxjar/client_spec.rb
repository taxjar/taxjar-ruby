require 'helper'

describe Taxjar::Client do
  describe '#api_key?' do 
    it 'returns true if api_key is present' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect(client.api_key?).to be true
    end

    it 'returns false if api_key is not present' do
      client = Taxjar::Client.new
      expect(client.api_key?).to be false
    end
  end

  describe '#user_agent' do
    it 'returns string with version' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect(client.user_agent).to eq("TaxjarRubyGem/#{Taxjar::Version}")
    end
  end
end
