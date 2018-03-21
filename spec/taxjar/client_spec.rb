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

  describe "#set_api_config" do
    it 'sets new api key' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_key', 'ZZ')
      expect(client.api_key).to eq('ZZ')
    end

    it 'sets new api url' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_url', 'https://api.sandbox.taxjar.com')
      expect(client.api_url).to eq('https://api.sandbox.taxjar.com')
    end
    
    it 'sets new custom headers' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('headers', { 'X-TJ-Expected-Response' => 422 })
      expect(client.headers).to eq({ 'X-TJ-Expected-Response' => 422 })
    end
  end
  
  describe "#get_api_config" do
    it 'gets a config value' do
      client = Taxjar::Client.new(api_key: 'AK')
      client.set_api_config('api_key', 'ZZ')
      expect(client.get_api_config('api_key')).to eq('ZZ')
    end
  end

  describe '#user_agent' do
    it 'returns string with version' do
      client = Taxjar::Client.new(api_key: 'AK')
      expect(client.user_agent).to eq("TaxjarRubyGem/#{Taxjar::Version}")
    end
  end
end
