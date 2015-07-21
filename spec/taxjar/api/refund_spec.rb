require 'helper'

describe Taxjar::API::Refund do

  before do
    @client = Taxjar::Client.new(api_key: 'AK')
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

    it 'returns the created order' do
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
end
