require 'helper'

describe Taxjar::API do

  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe '#categories' do
    before do
      stub_get('/v2/enhanced/categories').to_return(body: fixture('categories.json'),
                                                    headers: {content_type: 'application/json; charset=utf-8'})

    end

    it 'requests the right resource' do
      @client.categories
      expect(a_get('/v2/enhanced/categories')).to have_been_made
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
      stub_get("/v2/enhanced/rates/#{@postal_code}").to_return(body: fixture('rates.json'),
                                headers: {content_type: 'application/json; charset=utf-8'})

    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/enhanced/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.county).to eq('LOS ANGELES')
    end
  end

  describe "#tax_for_order" do
    before do
      stub_post("/v2/enhanced/taxes").to_return(body: fixture('taxes.json'),
                                headers: {content_type: 'application/json; charset=utf-8'})

      @order = {:from_country => 'US',
                   :from_zip => '92806',
                   :from_state => 'CA',
                   :from_city => 'Anaheim',
                   :from_street => '1731 N. Pheasant St.',
                   :to_state => 'CA',
                   :to_city => 'Santa Barbara',
                   :to_street => '500 N. Molina',
                   :amount => 15.02,
                   :shipping => 1.5,
                   :line_items => [{:line_item => {:quantity => 1,
                                                   :unit_price => 15.0,
                                                   :product_tax_code => 20010}}]
                  }
    end

    it 'requests the right resource' do
      @client.tax_for_order(@order)
      expect(a_post("/v2/enhanced/taxes")).to have_been_made
    end

    it 'returns the requested taxes' do
      tax = @client.tax_for_order(@order)
      expect(tax).to be_a Taxjar::Tax
      expect(tax.tax_source).to eq('destination')
    end
  end
end
