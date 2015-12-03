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
      expect(categories.first.product_tax_code).to eq('31000')
      expect(categories.first.description).to eq('Digital products transferred electronically, meaning obtained by the purchaser by means other than tangible storage media.')
    end
  end

  describe '#rate_for_location' do
    before do
      @postal_code = "90210"
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates.json'),
                                                      headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.zip).to eq('90002')
      expect(rates.state).to eq('CA')
      expect(rates.state_rate).to eq(0.065)
      expect(rates.county).to eq('LOS ANGELES')
      expect(rates.county_rate).to eq(0.01)
      expect(rates.city).to eq('WATTS')
      expect(rates.city_rate).to eq(0.0)
      expect(rates.combined_district_rate).to eq(0.015)
      expect(rates.combined_rate).to eq(0.09)
    end
  end
  
  describe '#rate_for_location (international)' do
    before do
      @postal_code = "00150"
      @params = "city=Helsinki&country=FI"
      stub_get("/v2/rates/#{@postal_code}?#{@params}").to_return(body: fixture('rates_intl.json'),
                                      headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.rates_for_location('00150', {
        :city => 'Helsinki',
        :country => 'FI'
      })
      expect(a_get("/v2/rates/#{@postal_code}?#{@params}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code, {
        :city => 'Helsinki',
        :country => 'FI'
      })
      expect(rates).to be_a Taxjar::Rate
      expect(rates.country).to eq('FI')
      expect(rates.name).to eq('Finland')
      expect(rates.standard_rate).to eq(0.24)
      expect(rates.reduced_rate).to eq(0)
      expect(rates.super_reduced_rate).to eq(0)
      expect(rates.parking_rate).to eq(0)
      expect(rates.distance_sale_threshold).to eq(0)
      expect(rates.freight_taxable).to eq(true)
    end
  end

  describe "#tax_for_order" do
    before do
      stub_post("/v2/taxes").to_return(body: fixture('taxes.json'),
                                                headers: {content_type: 'application/json; charset=utf-8'})

      @order = {:from_country => 'US',
                :from_zip => '07001',
                :from_state => 'NJ',
                :to_zip => '07446',
                :amount => 16.50,
                :shipping => 1.5,
                :line_items => [{:line_item => {:quantity => 1,
                                                :unit_price => 15.0,
                                                :product_tax_code => '20010'}}]
      }
    end

    it 'requests the right resource' do
      @client.tax_for_order(@order)
      expect(a_post("/v2/taxes")).to have_been_made
    end

    it 'returns the requested taxes' do
      tax = @client.tax_for_order(@order)
      expect(tax).to be_a Taxjar::Tax
      expect(tax.order_total_amount).to eq(16.5)
      expect(tax.amount_to_collect).to eq(1.16)
      expect(tax.has_nexus).to eq(true)
      expect(tax.freight_taxable).to eq(true)
      expect(tax.tax_source).to eq('destination')
    end
    
    it 'allows access to breakdown' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.state_taxable_amount).to eq(16.5)
      expect(tax.breakdown.state_tax_collectable).to eq(1.16)
      expect(tax.breakdown.county_taxable_amount).to eq(0)
      expect(tax.breakdown.county_tax_collectable).to eq(0)
      expect(tax.breakdown.city_taxable_amount).to eq(0)
      expect(tax.breakdown.city_tax_collectable).to eq(0)
      expect(tax.breakdown.special_district_taxable_amount).to eq(0)
      expect(tax.breakdown.special_district_tax_collectable).to eq(0)
    end
    
    it 'allows access to breakdown.shipping' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.shipping.state_amount).to eq(0.11)
      expect(tax.breakdown.shipping.state_sales_tax_rate).to eq(0.07)
      expect(tax.breakdown.shipping.county_amount).to eq(0)
      expect(tax.breakdown.shipping.county_tax_rate).to eq(0)
      expect(tax.breakdown.shipping.city_amount).to eq(0)
      expect(tax.breakdown.shipping.city_tax_rate).to eq(0)
      expect(tax.breakdown.shipping.special_district_amount).to eq(0)
      expect(tax.breakdown.shipping.special_tax_rate).to eq(0)
    end

    it 'allows access to breakdown.line_items' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.line_items[0].id).to eq(1)
      expect(tax.breakdown.line_items[0].state_taxable_amount).to eq(15)
      expect(tax.breakdown.line_items[0].state_sales_tax_rate).to eq(0.07)
      expect(tax.breakdown.line_items[0].county_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].county_tax_rate).to eq(0)
      expect(tax.breakdown.line_items[0].city_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].city_tax_rate).to eq(0)
      expect(tax.breakdown.line_items[0].special_district_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].special_tax_rate).to eq(0)
    end
  end
end
