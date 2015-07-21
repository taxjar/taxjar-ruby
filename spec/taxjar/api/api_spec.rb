require 'helper'

describe Taxjar::API do

  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe '#categories' do
    before do
      stub_get('/v2/categories').to_return(body: fixture('categories.json'),
                                                    headers: {content_type: 'application/json; charset=utf-8'})

    end

    it 'requests the right resource' do
      @client.categories
      expect(a_get('/v2/categories')).to have_been_made
    end

    it 'returns the requested categories' do
      categories = @client.categories
      expect(categories).to be_an Array
      expect(categories.first).to be_a Taxjar::Category
      expect(categories.first.name).to eq('Digital Goods')
    end
  end

  describe '#rate_for_location' do
    before do
      @postal_code = "90210"
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates.json'),
                                                               headers: {content_type: 'application/json; charset=utf-8'})

    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.county).to eq('LOS ANGELES')
    end
  end

end
