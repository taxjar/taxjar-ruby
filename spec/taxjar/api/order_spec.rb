require 'helper'

describe Taxjar::API::Order do

  before do
    @client = Taxjar::Client.new(api_key: 'AK')
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
      expect(tax.tax_source).to eq('destination')
    end
  end

  describe "#create_order" do
    before do
      stub_post("/v2/transactions/orders").to_return(body: fixture('order.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @order = {:transaction_id => '123',
                :transaction_date => '2015/05/14',
                :to_country => 'US',
                :to_zip => '90002',
                :to_city => 'Los Angeles',
                :to_street => '123 Palm Grove Ln',
                :amount => 17.45,
                :shipping => 1.5,
                :sales_tax => 0.95,
                :line_items => [{:quantity => 1,
                                 :product_identifier => '12-34243-9',
                                 :descriptiion => 'Fuzzy Widget',
                                 :unit_price => 15.0,
                                 :sales_tax => 0.95}]
      }
    end

    it 'requests the right resource' do
      @client.create_order(@order)
      expect(a_post("/v2/transactions/orders")).to have_been_made
    end

    it 'returns the created order' do
      order = @client.create_order(@order)
      expect(order).to be_a Taxjar::Order
      expect(order.transaction_id).to eq(123)
    end
  end

  describe "#update_order" do
    before do
      @order_id = 123
      stub_put("/v2/transactions/orders/#{@order_id}").to_return(body: fixture('order.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @order = {:transaction_id => '123',
                :amount => 17.95,
                :shipping => 2.0,
                :line_items => [{:quantity => 1,
                                 :product_identifier => '12-34243-0',
                                 :descriptiion => 'Heavy  Widget',
                                 :unit_price => 15.0,
                                 :discount => 0.0,
                                 :sales_tax => 0.95}]
      }
    end

    it 'requests the right resource' do
      @client.update_order(@order)
      expect(a_put("/v2/transactions/orders/#{@order_id}")).to have_been_made
    end

    it 'returns the updated order' do
      order = @client.update_order(@order)
      expect(order).to be_a Taxjar::Order
      expect(order.transaction_id).to eq(123)
    end
  end

end
