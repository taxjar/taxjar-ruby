require 'helper'

describe Taxjar::API::Order do
  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe "#list_orders" do
    context "without parameters" do
      before do
        stub_get('/v2/transactions/orders').to_return(body: fixture('orders.json'),
                                                      headers: {content_type: 'application/json; charset=utf-8'})

      end

      it 'requests the right resource' do
        @client.list_orders
        expect(a_get('/v2/transactions/orders')).to have_been_made
      end

      it 'returns the requested orders' do
        orders = @client.list_orders
        expect(orders).to be_an Array
        expect(orders.first).to be_a String
        expect(orders.first).to eq('123')
      end
    end

    context "with parameters" do
      before do
        stub_get('/v2/transactions/orders?from_transaction_date=2015/05/01&to_transaction_date=2015/05/31').
          to_return(body: fixture('orders.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})

      end

      it 'requests the right resource' do
        @client.list_orders(from_transaction_date: '2015/05/01',
                                     to_transaction_date: '2015/05/31')
        expect(a_get('/v2/transactions/orders?from_transaction_date=2015/05/01&to_transaction_date=2015/05/31')).to have_been_made
      end

      it 'returns the requested orders' do
        orders = @client.list_orders(from_transaction_date: '2015/05/01',
                                     to_transaction_date: '2015/05/31')
        expect(orders).to be_an Array
        expect(orders.first).to be_a String
        expect(orders.first).to eq('123')
      end
    end
  end

  describe "#show_order" do
    before do
        stub_get('/v2/transactions/orders/123').
          to_return(body: fixture('order.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.show_order('123')
      expect(a_get('/v2/transactions/orders/123')).to have_been_made
    end

    it 'returns the requested order' do
      order = @client.show_order('123')
      expect(order).to be_an Taxjar::Order
      expect(order.transaction_id).to eq('123')
      expect(order.user_id).to eq(10649)
      expect(order.transaction_date).to eq('2015-05-14T00:00:00Z')
      expect(order.from_country).to eq('US')
      expect(order.from_zip).to eq('93107')
      expect(order.from_state).to eq('CA')
      expect(order.from_city).to eq('SANTA BARBARA')
      expect(order.from_street).to eq('1281 State St')
      expect(order.to_country).to eq('US')
      expect(order.to_zip).to eq('90002')
      expect(order.to_state).to eq('CA')
      expect(order.to_city).to eq('LOS ANGELES')
      expect(order.to_street).to eq('123 Palm Grove Ln')
      expect(order.amount).to eq(17.45)
      expect(order.shipping).to eq(1.5)
      expect(order.sales_tax).to eq(0.95)
    end

    it 'allows access to line_items' do
      order = @client.show_order('123')
      expect(order.line_items[0].id).to eq('1')
      expect(order.line_items[0].quantity).to eq(1)
      expect(order.line_items[0].product_identifier).to eq('12-34243-9')
      expect(order.line_items[0].description).to eq('Fuzzy Widget')
      expect(order.line_items[0].unit_price).to eq(15.0)
      expect(order.line_items[0].sales_tax).to eq(0.95)
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
                :line_items => [{:id => 1,
                                 :quantity => 1,
                                 :product_identifier => '12-34243-9',
                                 :description => 'Fuzzy Widget',
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
      expect(order.transaction_id).to eq('123')
      expect(order.user_id).to eq(10649)
      expect(order.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(order.from_country).to eq('US')
      expect(order.from_zip).to eq('93107')
      expect(order.from_state).to eq('CA')
      expect(order.from_city).to eq('SANTA BARBARA')
      expect(order.from_street).to eq('1281 State St')
      expect(order.to_country).to eq('US')
      expect(order.to_zip).to eq('90002')
      expect(order.to_state).to eq('CA')
      expect(order.to_city).to eq('LOS ANGELES')
      expect(order.to_street).to eq('123 Palm Grove Ln')
      expect(order.amount).to eq(17.45)
      expect(order.shipping).to eq(1.5)
      expect(order.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      order = @client.create_order(@order)
      expect(order.line_items[0].id).to eq('1')
      expect(order.line_items[0].quantity).to eq(1)
      expect(order.line_items[0].product_identifier).to eq('12-34243-9')
      expect(order.line_items[0].description).to eq('Fuzzy Widget')
      expect(order.line_items[0].unit_price).to eq(15.0)
      expect(order.line_items[0].sales_tax).to eq(0.95)
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
                :line_items => [{:id => 1,
                                 :quantity => 1,
                                 :product_identifier => '12-34243-0',
                                 :description => 'Heavy  Widget',
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
      expect(order.transaction_id).to eq('123')
      expect(order.user_id).to eq(10649)
      expect(order.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(order.from_country).to eq('US')
      expect(order.from_zip).to eq('93107')
      expect(order.from_state).to eq('CA')
      expect(order.from_city).to eq('SANTA BARBARA')
      expect(order.from_street).to eq('1281 State St')
      expect(order.to_country).to eq('US')
      expect(order.to_zip).to eq('90002')
      expect(order.to_state).to eq('CA')
      expect(order.to_city).to eq('LOS ANGELES')
      expect(order.to_street).to eq('123 Palm Grove Ln')
      expect(order.amount).to eq(17.45)
      expect(order.shipping).to eq(1.5)
      expect(order.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      order = @client.update_order(@order)
      expect(order.line_items[0].id).to eq('1')
      expect(order.line_items[0].quantity).to eq(1)
      expect(order.line_items[0].product_identifier).to eq('12-34243-9')
      expect(order.line_items[0].description).to eq('Fuzzy Widget')
      expect(order.line_items[0].unit_price).to eq(15.0)
      expect(order.line_items[0].sales_tax).to eq(0.95)
    end
  end

  describe "#delete_order" do
    before do
        stub_delete('/v2/transactions/orders/123').
          to_return(body: fixture('order.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.delete_order('123')
      expect(a_delete('/v2/transactions/orders/123')).to have_been_made
    end

    it 'returns the deleted order' do
      order = @client.delete_order('123')
      expect(order).to be_an Taxjar::Order
      expect(order.transaction_id).to eq('123')
      expect(order.user_id).to eq(10649)
      expect(order.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(order.from_country).to eq('US')
      expect(order.from_zip).to eq('93107')
      expect(order.from_state).to eq('CA')
      expect(order.from_city).to eq('SANTA BARBARA')
      expect(order.from_street).to eq('1281 State St')
      expect(order.to_country).to eq('US')
      expect(order.to_zip).to eq('90002')
      expect(order.to_state).to eq('CA')
      expect(order.to_city).to eq('LOS ANGELES')
      expect(order.to_street).to eq('123 Palm Grove Ln')
      expect(order.amount).to eq(17.45)
      expect(order.shipping).to eq(1.5)
      expect(order.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line items' do
      order = @client.delete_order('123')
      expect(order.line_items[0].id).to eq('1')
      expect(order.line_items[0].quantity).to eq(1)
      expect(order.line_items[0].product_identifier).to eq('12-34243-9')
      expect(order.line_items[0].description).to eq('Fuzzy Widget')
      expect(order.line_items[0].unit_price).to eq(15.0)
      expect(order.line_items[0].sales_tax).to eq(0.95)
    end
  end

end
