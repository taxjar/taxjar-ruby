require 'helper'

describe Taxjar::API do
  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe '#categories' do
    before do
      stub_get('/v2/categories').to_return(body: fixture('categories.json'), headers: { content_type: 'application/json; charset=utf-8' })
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
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates.json'), headers: { content_type: 'application/json; charset=utf-8' })
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
      expect(rates.freight_taxable).to eq(false)
    end
  end

  describe '#rate_for_location (sst)' do
    before do
      @postal_code = "05495-2086"
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates_sst.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.zip).to eq('05495-2086')
      expect(rates.country).to eq('US')
      expect(rates.country_rate).to eq(0.0)
      expect(rates.state).to eq('VT')
      expect(rates.state_rate).to eq(0.06)
      expect(rates.county).to eq('CHITTENDEN')
      expect(rates.county_rate).to eq(0.0)
      expect(rates.city).to eq('WILLISTON')
      expect(rates.city_rate).to eq(0.0)
      expect(rates.combined_district_rate).to eq(0.01)
      expect(rates.combined_rate).to eq(0.07)
      expect(rates.freight_taxable).to eq(true)
    end
  end

  describe '#rate_for_location (ca)' do
    before do
      @postal_code = "V5K0A1"
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates_ca.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.zip).to eq('V5K0A1')
      expect(rates.city).to eq('Vancouver')
      expect(rates.state).to eq('BC')
      expect(rates.country).to eq('CA')
      expect(rates.combined_rate).to eq(0.12)
      expect(rates.freight_taxable).to eq(true)
    end
  end

  describe '#rate_for_location (au)' do
    before do
      @postal_code = "2060"
      stub_get("/v2/rates/#{@postal_code}").to_return(body: fixture('rates_au.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.rates_for_location(@postal_code)
      expect(a_get("/v2/rates/#{@postal_code}")).to have_been_made
    end

    it 'returns the requested rates' do
      rates = @client.rates_for_location(@postal_code)
      expect(rates).to be_a Taxjar::Rate
      expect(rates.zip).to eq('2060')
      expect(rates.country).to eq('AU')
      expect(rates.country_rate).to eq(0.1)
      expect(rates.combined_rate).to eq(0.1)
      expect(rates.freight_taxable).to eq(true)
    end
  end
  
  describe '#rate_for_location (eu)' do
    before do
      @postal_code = "00150"
      @params = "city=Helsinki&country=FI"
      stub_get("/v2/rates/#{@postal_code}?#{@params}").to_return(body: fixture('rates_eu.json'), headers: { content_type: 'application/json; charset=utf-8' })
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
      stub_post("/v2/taxes").to_return(body: fixture('taxes.json'), headers: {content_type: 'application/json; charset=utf-8'})

      @order = {:from_country => 'US',
                :from_zip => '07001',
                :from_state => 'NJ',
                :to_zip => '07446',
                :amount => 16.50,
                :shipping => 1.5,
                :line_items => [{:line_item => {:id => '1',
                                                :quantity => 1,
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
      expect(tax.shipping).to eq(1.5)
      expect(tax.taxable_amount).to eq(16.5)
      expect(tax.amount_to_collect).to eq(1.16)
      expect(tax.rate).to eq(0.07)
      expect(tax.has_nexus).to eq(true)
      expect(tax.freight_taxable).to eq(true)
      expect(tax.tax_source).to eq('destination')
    end
    
    it 'allows access to breakdown' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.state_taxable_amount).to eq(16.5)
      expect(tax.breakdown.state_tax_collectable).to eq(1.16)
      expect(tax.breakdown.combined_tax_rate).to eq(0.07)
      expect(tax.breakdown.state_taxable_amount).to eq(16.5)
      expect(tax.breakdown.state_tax_rate).to eq(0.07)
      expect(tax.breakdown.state_tax_collectable).to eq(1.16)
      expect(tax.breakdown.county_taxable_amount).to eq(0)
      expect(tax.breakdown.county_tax_rate).to eq(0)
      expect(tax.breakdown.county_tax_collectable).to eq(0)
      expect(tax.breakdown.city_taxable_amount).to eq(0)
      expect(tax.breakdown.city_tax_rate).to eq(0)
      expect(tax.breakdown.city_tax_collectable).to eq(0)
      expect(tax.breakdown.special_district_taxable_amount).to eq(0)
      expect(tax.breakdown.special_tax_rate).to eq(0)
      expect(tax.breakdown.special_district_tax_collectable).to eq(0)
    end
    
    it 'allows access to breakdown.shipping' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.shipping.taxable_amount).to eq(1.5)
      expect(tax.breakdown.shipping.tax_collectable).to eq(0.11)
      expect(tax.breakdown.shipping.state_taxable_amount).to eq(1.5)
      expect(tax.breakdown.shipping.state_amount).to eq(0.11)
      expect(tax.breakdown.shipping.state_sales_tax_rate).to eq(0.07)
      expect(tax.breakdown.shipping.state_amount).to eq(0.11)
      expect(tax.breakdown.shipping.county_taxable_amount).to eq(0)
      expect(tax.breakdown.shipping.county_tax_rate).to eq(0)
      expect(tax.breakdown.shipping.county_amount).to eq(0)
      expect(tax.breakdown.shipping.city_taxable_amount).to eq(0)
      expect(tax.breakdown.shipping.city_tax_rate).to eq(0)
      expect(tax.breakdown.shipping.city_amount).to eq(0)
      expect(tax.breakdown.shipping.special_taxable_amount).to eq(0)
      expect(tax.breakdown.shipping.special_tax_rate).to eq(0)
      expect(tax.breakdown.shipping.special_district_amount).to eq(0)
    end

    it 'allows access to breakdown.line_items' do
      tax = @client.tax_for_order(@order)
      expect(tax.breakdown.line_items[0].id).to eq('1')
      expect(tax.breakdown.line_items[0].taxable_amount).to eq(15)
      expect(tax.breakdown.line_items[0].tax_collectable).to eq(1.05)
      expect(tax.breakdown.line_items[0].combined_tax_rate).to eq(0.07)
      expect(tax.breakdown.line_items[0].state_taxable_amount).to eq(15)
      expect(tax.breakdown.line_items[0].state_sales_tax_rate).to eq(0.07)
      expect(tax.breakdown.line_items[0].state_amount).to eq(1.05)
      expect(tax.breakdown.line_items[0].county_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].county_tax_rate).to eq(0)
      expect(tax.breakdown.line_items[0].county_amount).to eq(0)
      expect(tax.breakdown.line_items[0].city_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].city_tax_rate).to eq(0)
      expect(tax.breakdown.line_items[0].city_amount).to eq(0)
      expect(tax.breakdown.line_items[0].special_district_taxable_amount).to eq(0)
      expect(tax.breakdown.line_items[0].special_tax_rate).to eq(0)
      expect(tax.breakdown.line_items[0].special_district_amount).to eq(0)
    end

    describe "international orders" do
      before do
        stub_post("/v2/taxes").to_return(body: fixture('taxes_international.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'returns the requested taxes' do
        tax = @client.tax_for_order(@order)
        expect(tax).to be_a Taxjar::Tax
        expect(tax.order_total_amount).to eq(26.95)
        expect(tax.shipping).to eq(10)
        expect(tax.taxable_amount).to eq(26.95)
        expect(tax.amount_to_collect).to eq(6.47)
        expect(tax.rate).to eq(0.24)
        expect(tax.has_nexus).to eq(true)
        expect(tax.freight_taxable).to eq(true)
        expect(tax.tax_source).to eq('destination')
      end
      
      it 'allows access to breakdown' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.taxable_amount).to eq(26.95)
        expect(tax.breakdown.tax_collectable).to eq(6.47)
        expect(tax.breakdown.combined_tax_rate).to eq(0.24)
        expect(tax.breakdown.country_taxable_amount).to eq(26.95)
        expect(tax.breakdown.country_tax_rate).to eq(0.24)
        expect(tax.breakdown.country_tax_collectable).to eq(6.47)
      end
      
      it 'allows access to breakdown.shipping' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.shipping.taxable_amount).to eq(10)
        expect(tax.breakdown.shipping.tax_collectable).to eq(2.4)
        expect(tax.breakdown.shipping.combined_tax_rate).to eq(0.24)
        expect(tax.breakdown.shipping.country_taxable_amount).to eq(10)
        expect(tax.breakdown.shipping.country_tax_rate).to eq(0.24)
        expect(tax.breakdown.shipping.country_tax_collectable).to eq(2.4)
      end

      it 'allows access to breakdown.line_items' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.line_items[0].id).to eq('1')
        expect(tax.breakdown.line_items[0].taxable_amount).to eq(16.95)
        expect(tax.breakdown.line_items[0].tax_collectable).to eq(4.07)
        expect(tax.breakdown.line_items[0].combined_tax_rate).to eq(0.24)
        expect(tax.breakdown.line_items[0].country_taxable_amount).to eq(16.95)
        expect(tax.breakdown.line_items[0].country_tax_rate).to eq(0.24)
        expect(tax.breakdown.line_items[0].country_tax_collectable).to eq(4.07)
      end
    end

    describe "canadian orders" do
      before do
        stub_post("/v2/taxes").to_return(body: fixture('taxes_canada.json'), headers: {content_type: 'application/json; charset=utf-8'})
      end

      it 'returns the requested taxes' do
        tax = @client.tax_for_order(@order)
        expect(tax).to be_a Taxjar::Tax
        expect(tax.order_total_amount).to eq(26.95)
        expect(tax.shipping).to eq(10)
        expect(tax.taxable_amount).to eq(26.95)
        expect(tax.amount_to_collect).to eq(3.5)
        expect(tax.rate).to eq(0.13)
        expect(tax.has_nexus).to eq(true)
        expect(tax.freight_taxable).to eq(true)
        expect(tax.tax_source).to eq('destination')
      end
      
      it 'allows access to breakdown' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.taxable_amount).to eq(26.95)
        expect(tax.breakdown.tax_collectable).to eq(3.5)
        expect(tax.breakdown.combined_tax_rate).to eq(0.13)
        expect(tax.breakdown.gst_taxable_amount).to eq(26.95)
        expect(tax.breakdown.gst_tax_rate).to eq(0.05)
        expect(tax.breakdown.gst).to eq(1.35)
        expect(tax.breakdown.pst_taxable_amount).to eq(26.95)
        expect(tax.breakdown.pst_tax_rate).to eq(0.08)
        expect(tax.breakdown.pst).to eq(2.16)
        expect(tax.breakdown.qst_taxable_amount).to eq(0)
        expect(tax.breakdown.qst_tax_rate).to eq(0)
        expect(tax.breakdown.qst).to eq(0)
      end
      
      it 'allows access to breakdown.shipping' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.shipping.taxable_amount).to eq(10)
        expect(tax.breakdown.shipping.tax_collectable).to eq(1.3)
        expect(tax.breakdown.shipping.combined_tax_rate).to eq(0.13)
        expect(tax.breakdown.shipping.gst_taxable_amount).to eq(10)
        expect(tax.breakdown.shipping.gst_tax_rate).to eq(0.05)
        expect(tax.breakdown.shipping.gst).to eq(0.5)
        expect(tax.breakdown.shipping.pst_taxable_amount).to eq(10)
        expect(tax.breakdown.shipping.pst_tax_rate).to eq(0.08)
        expect(tax.breakdown.shipping.pst).to eq(0.8)
        expect(tax.breakdown.shipping.qst_taxable_amount).to eq(0)
        expect(tax.breakdown.shipping.qst_tax_rate).to eq(0)
        expect(tax.breakdown.shipping.qst).to eq(0)
      end

      it 'allows access to breakdown.line_items' do
        tax = @client.tax_for_order(@order)
        expect(tax.breakdown.line_items[0].id).to eq('1')
        expect(tax.breakdown.line_items[0].taxable_amount).to eq(16.95)
        expect(tax.breakdown.line_items[0].tax_collectable).to eq(2.2)
        expect(tax.breakdown.line_items[0].combined_tax_rate).to eq(0.13)
        expect(tax.breakdown.line_items[0].gst_taxable_amount).to eq(16.95)
        expect(tax.breakdown.line_items[0].gst_tax_rate).to eq(0.05)
        expect(tax.breakdown.line_items[0].gst).to eq(0.85)
        expect(tax.breakdown.line_items[0].pst_taxable_amount).to eq(16.95)
        expect(tax.breakdown.line_items[0].pst_tax_rate).to eq(0.08)
        expect(tax.breakdown.line_items[0].pst).to eq(1.36)
        expect(tax.breakdown.line_items[0].qst_taxable_amount).to eq(0)
        expect(tax.breakdown.line_items[0].qst_tax_rate).to eq(0)
        expect(tax.breakdown.line_items[0].qst).to eq(0)
      end
    end
  end
  
  describe '#nexus_regions' do
    before do
      stub_get('/v2/nexus/regions').to_return(body: fixture('nexus_regions.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end
    
    it 'requests the right resource' do
      @client.nexus_regions
      expect(a_get('/v2/nexus/regions')).to have_been_made
    end

    it 'returns the requested regions' do
      regions = @client.nexus_regions
      expect(regions).to be_an Array
      expect(regions.first).to be_a Taxjar::NexusRegion
      expect(regions.first.country_code).to eq('US')
      expect(regions.first.country).to eq('United States')
      expect(regions.first.region_code).to eq('CA')
      expect(regions.first.region).to eq('California')
    end
  end
  
  describe '#validate' do
    before do
      @params = 'vat=FR40303265045'
      stub_get("/v2/validation?#{@params}").to_return(body: fixture('validation.json'), headers: { content_type: 'application/json; charset=utf-8' })
      @validation = {
        :vat => 'FR40303265045'
      }
    end

    it 'requests the right resource' do
      @client.validate(@validation)
      expect(a_get("/v2/validation?#{@params}")).to have_been_made
    end

    it 'returns the requested validation' do
      validation = @client.validate(@validation)
      expect(validation).to be_a Taxjar::Validation
      expect(validation.valid).to eq(true)
      expect(validation.exists).to eq(true)
      expect(validation.vies_available).to eq(true)
      expect(validation.vies_response.vat_number).to eq('40303265045')
      expect(validation.vies_response.request_date).to eq('2016-02-10')
      expect(validation.vies_response.valid).to eq(true)
      expect(validation.vies_response.name).to eq('SA SODIMAS')
      expect(validation.vies_response.address).to eq("11 RUE AMPERE\n26600 PONT DE L ISERE")
    end
  end
  
  describe '#summary_rates' do
    before do
      stub_get('/v2/summary_rates').to_return(body: fixture('summary_rates.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end

    it 'requests the right resource' do
      @client.summary_rates
      expect(a_get('/v2/summary_rates')).to have_been_made
    end

    it 'returns the requested summarized rates' do
      summarized_rates = @client.summary_rates
      expect(summarized_rates).to be_an Array
      expect(summarized_rates.first).to be_a Taxjar::SummaryRate
      expect(summarized_rates.first.country_code).to eq('US')
      expect(summarized_rates.first.country).to eq('United States')
      expect(summarized_rates.first.region_code).to eq('CA')
      expect(summarized_rates.first.region).to eq('California')
      expect(summarized_rates.first.minimum_rate.label).to eq('State Tax')
      expect(summarized_rates.first.minimum_rate.rate).to eq(0.065)
      expect(summarized_rates.first.average_rate.label).to eq('Tax')
      expect(summarized_rates.first.average_rate.rate).to eq(0.0827)
    end
  end
end
