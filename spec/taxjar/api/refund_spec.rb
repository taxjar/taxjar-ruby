require 'helper'

describe Taxjar::API::Refund do
  before do
    @client = Taxjar::Client.new(api_key: 'AK')
  end

  describe "#list_refunds" do
    context "without parameters" do
      before do
        stub_get('/v2/transactions/refunds').to_return(body: fixture('refunds.json'),
                                                      headers: {content_type: 'application/json; charset=utf-8'})

      end

      it 'requests the right resource' do
        @client.list_refunds
        expect(a_get('/v2/transactions/refunds')).to have_been_made
      end

      it 'returns the requested refunds' do
        refunds = @client.list_refunds
        expect(refunds).to be_an Array
        expect(refunds.first).to be_a String
        expect(refunds.first).to eq('321')
      end
    end

    context "with parameters" do
      before do
        stub_get('/v2/transactions/refunds?from_transaction_date=2015/05/01&to_transaction_date=2015/05/31').
          to_return(body: fixture('refunds.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})

      end

      it 'requests the right resource' do
        @client.list_refunds(from_transaction_date: '2015/05/01',
                                     to_transaction_date: '2015/05/31')
        expect(a_get('/v2/transactions/refunds?from_transaction_date=2015/05/01&to_transaction_date=2015/05/31')).to have_been_made
      end

      it 'returns the requested refunds' do
        refunds = @client.list_refunds(from_transaction_date: '2015/05/01',
                                     to_transaction_date: '2015/05/31')
        expect(refunds).to be_an Array
        expect(refunds.first).to be_a String
        expect(refunds.first).to eq('321')
      end
    end
  end

  describe "#show_refund" do
    before do
        stub_get('/v2/transactions/refunds/321').
          to_return(body: fixture('refund.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.show_refund('321')
      expect(a_get('/v2/transactions/refunds/321')).to have_been_made
    end

    it 'returns the requested refund' do
      refund = @client.show_refund('321')
      expect(refund).to be_an Taxjar::Refund
      expect(refund.transaction_id).to eq('321')
      expect(refund.user_id).to eq(10649)
      expect(refund.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(refund.transaction_reference_id).to eq("123")
      expect(refund.from_country).to eq('US')
      expect(refund.from_zip).to eq('93107')
      expect(refund.from_state).to eq('CA')
      expect(refund.from_city).to eq('SANTA BARBARA')
      expect(refund.from_street).to eq('1281 State St')
      expect(refund.to_country).to eq('US')
      expect(refund.to_zip).to eq('90002')
      expect(refund.to_state).to eq('CA')
      expect(refund.to_city).to eq('LOS ANGELES')
      expect(refund.to_street).to eq('123 Palm Grove Ln')
      expect(refund.amount).to eq(17.45)
      expect(refund.shipping).to eq(1.5)
      expect(refund.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      refund = @client.show_refund('321')
      expect(refund.line_items[0].id).to eq('1')
      expect(refund.line_items[0].quantity).to eq(1)
      expect(refund.line_items[0].product_identifier).to eq('12-34243-9')
      expect(refund.line_items[0].description).to eq('Fuzzy Widget')
      expect(refund.line_items[0].unit_price).to eq(15.0)
      expect(refund.line_items[0].discount).to eq(0.0)
      expect(refund.line_items[0].sales_tax).to eq(0.95)
    end
  end

  describe "#create_refund" do
    before do
      stub_post("/v2/transactions/refunds").to_return(body: fixture('refund.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @refund = {:transaction_id => '321',
                :transaction_date => '2015/05/14',
                :transaction_reference_id => '123',
                :to_country => 'US',
                :to_zip => '90002',
                :to_state => 'CA',
                :to_city => 'Los Angeles',
                :to_street => '123 Palm Grove Ln',
                :amount => 17.45,
                :shipping => 1.5,
                :sales_tax => 0.95,
                :line_items => [{:quantity => 1,
                                 :product_identifier => '12-34243-9',
                                 :description => 'Fuzzy Widget',
                                 :unit_price => 15.0,
                                 :sales_tax => 0.95}]
      }
    end

    it 'requests the right resource' do
      @client.create_refund(@refund)
      expect(a_post("/v2/transactions/refunds")).to have_been_made
    end

    it 'returns the created refund' do
      refund = @client.create_refund(@refund)
      expect(refund).to be_a Taxjar::Refund
      expect(refund.transaction_id).to eq('321')
      expect(refund.user_id).to eq(10649)
      expect(refund.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(refund.transaction_reference_id).to eq("123")
      expect(refund.from_country).to eq('US')
      expect(refund.from_zip).to eq('93107')
      expect(refund.from_state).to eq('CA')
      expect(refund.from_city).to eq('SANTA BARBARA')
      expect(refund.from_street).to eq('1281 State St')
      expect(refund.to_country).to eq('US')
      expect(refund.to_zip).to eq('90002')
      expect(refund.to_state).to eq('CA')
      expect(refund.to_city).to eq('LOS ANGELES')
      expect(refund.to_street).to eq('123 Palm Grove Ln')
      expect(refund.amount).to eq(17.45)
      expect(refund.shipping).to eq(1.5)
      expect(refund.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      refund = @client.create_refund(@refund)
      expect(refund.line_items[0].id).to eq('1')
      expect(refund.line_items[0].quantity).to eq(1)
      expect(refund.line_items[0].product_identifier).to eq('12-34243-9')
      expect(refund.line_items[0].description).to eq('Fuzzy Widget')
      expect(refund.line_items[0].unit_price).to eq(15.0)
      expect(refund.line_items[0].discount).to eq(0.0)
      expect(refund.line_items[0].sales_tax).to eq(0.95)
    end
  end

  describe "#update_refund" do
    before do
      @refund_id = 321
      stub_put("/v2/transactions/refunds/#{@refund_id}").to_return(body: fixture('refund.json'),
                                            headers: {content_type: 'application/json; charset=utf-8'})

      @refund = {:transaction_id => '321',
                :amount => 17.95,
                :shipping => 2.0,
                :sales_tax => 0.95,
                :line_items => [{:quantity => 1,
                                 :product_identifier => '12-34243-9',
                                 :description => 'Heavy Widget',
                                 :unit_price => 15.0,
                                 :sales_tax => 0.95}]
      }
    end

    it 'requests the right resource' do
      @client.update_refund(@refund)
      expect(a_put("/v2/transactions/refunds/#{@refund_id}")).to have_been_made
    end

    it 'returns the updated refund' do
      refund = @client.update_refund(@refund)
      expect(refund).to be_a Taxjar::Refund
      expect(refund.transaction_id).to eq('321')
      expect(refund.user_id).to eq(10649)
      expect(refund.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(refund.transaction_reference_id).to eq("123")
      expect(refund.from_country).to eq('US')
      expect(refund.from_zip).to eq('93107')
      expect(refund.from_state).to eq('CA')
      expect(refund.from_city).to eq('SANTA BARBARA')
      expect(refund.from_street).to eq('1281 State St')
      expect(refund.to_country).to eq('US')
      expect(refund.to_zip).to eq('90002')
      expect(refund.to_state).to eq('CA')
      expect(refund.to_city).to eq('LOS ANGELES')
      expect(refund.to_street).to eq('123 Palm Grove Ln')
      expect(refund.amount).to eq(17.45)
      expect(refund.shipping).to eq(1.5)
      expect(refund.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      refund = @client.update_refund(@refund)
      expect(refund.line_items[0].id).to eq('1')
      expect(refund.line_items[0].quantity).to eq(1)
      expect(refund.line_items[0].product_identifier).to eq('12-34243-9')
      expect(refund.line_items[0].description).to eq('Fuzzy Widget')
      expect(refund.line_items[0].unit_price).to eq(15.0)
      expect(refund.line_items[0].discount).to eq(0.0)
      expect(refund.line_items[0].sales_tax).to eq(0.95)
    end
  end

  describe "#delete_refund" do
    before do
        stub_delete('/v2/transactions/refunds/321').
          to_return(body: fixture('refund.json'),
                    headers: {content_type: 'application/json; charset=utf-8'})
    end

    it 'requests the right resource' do
      @client.delete_refund('321')
      expect(a_delete('/v2/transactions/refunds/321')).to have_been_made
    end

    it 'returns the delete refund' do
      refund = @client.delete_refund('321')
      expect(refund).to be_an Taxjar::Refund
      expect(refund.transaction_id).to eq('321')
      expect(refund.user_id).to eq(10649)
      expect(refund.transaction_date).to eq("2015-05-14T00:00:00Z")
      expect(refund.transaction_reference_id).to eq("123")
      expect(refund.from_country).to eq('US')
      expect(refund.from_zip).to eq('93107')
      expect(refund.from_state).to eq('CA')
      expect(refund.from_city).to eq('SANTA BARBARA')
      expect(refund.from_street).to eq('1281 State St')
      expect(refund.to_country).to eq('US')
      expect(refund.to_zip).to eq('90002')
      expect(refund.to_state).to eq('CA')
      expect(refund.to_city).to eq('LOS ANGELES')
      expect(refund.to_street).to eq('123 Palm Grove Ln')
      expect(refund.amount).to eq(17.45)
      expect(refund.shipping).to eq(1.5)
      expect(refund.sales_tax).to eq(0.95)
    end
    
    it 'allows access to line_items' do
      refund = @client.delete_refund('321')
      expect(refund.line_items[0].id).to eq('1')
      expect(refund.line_items[0].quantity).to eq(1)
      expect(refund.line_items[0].product_identifier).to eq('12-34243-9')
      expect(refund.line_items[0].description).to eq('Fuzzy Widget')
      expect(refund.line_items[0].unit_price).to eq(15.0)
      expect(refund.line_items[0].discount).to eq(0.0)
      expect(refund.line_items[0].sales_tax).to eq(0.95)
    end
  end
end
