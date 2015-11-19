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
      expect(refund.transaction_id).to eq(321)
    end
    
    it 'allows access to line_items' do
      refund = @client.show_refund('321')
      expect(refund.line_items[0].quantity).to eq(1)
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
                                 :descriptiion => 'Fuzzy Widget',
                                 :unit_price => 15.0,
                                 :sales_tax => 0.95}]
      }
    end

    it 'requests the right resource' do
      @client.create_refund(@refund)
      expect(a_post("/v2/transactions/refunds")).to have_been_made
    end

    it 'returns the created refund' do
      refund  = @client.create_refund(@refund)
      expect(refund).to be_a Taxjar::Refund
      expect(refund.transaction_id).to eq(321)
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
                                 :descriptiion => 'Heavy Widget',
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
      expect(refund.transaction_id).to eq(321)
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
      expect(refund.transaction_id).to eq(321)
    end
  end
end
